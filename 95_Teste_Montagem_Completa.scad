/*
  Teste CSG das interfaces imprimiveis.
  Resultado correto: somente o cubo marcador de 1 mm em [1000,1000,0].
*/

include <00_Parametros.scad>;
use <01_Base_Trilho_X.scad>;
use <02_Carrinho_X.scad>;
use <03_Trilho_Y.scad>;
use <04_Carrinho_Y.scad>;
use <05_Modulo_Z_Caneta.scad>;

module run_collision_tests() {
translate([10000,1000,0]) cube([1,1,1]);

front_y=-base_w/2;
rear_y=x_rail_spacing-base_w/2;

module driven(px,dz=-0.02)
  translate([px-x_carriage_length/2,front_y,base_h+dz])
    carrinho_x_motriz();
module shoe(px,rail_error=0,dz=-0.02)
  translate([px-x_carriage_length/2,rear_y+rail_error,base_h+dz])
    sapata_x_passiva();
module saddle(px,dz=-0.02)
  translate([px-x_carriage_length/2,rear_y,
             base_h+passive_shoe_h+dz])
    sela_x_passiva();
module beam(px,with_rack=true)
  translate([px,0,y_beam_bottom_z]) trilho_y(include_rack=with_rack);
module cy(px,py)
  translate([px+y_dovetail_center_x-y_carriage_w/2,
             py-z_axis_center_y_local,y_beam_top_z+0.02]) carrinho_y();
module plunger(px,py,pz,with_rack=true)
  translate([px+y_dovetail_center_x-y_carriage_w/2+z_axis_center_x_local,
             py,z_plunger_down_z+pz])
    modulo_z_pen_plunger(include_rack=with_rack);

module pinion_x(px) {
  z=base_h+rack_pitch_height+gear_pitch_radius+gear_mesh_clearance;
  translate([px,front_y+x_rack_center_y-pinion_thickness/2,z])
    rotate([-90,0,0])
      rotate([0,0,pinion_angle(px,+1,pinion_phase_x)]) pinion_gear();
}
module pinion_y(px,py) {
  yy=py-z_axis_center_y_local+y_carriage_length/2;
  z=y_beam_top_z+rack_pitch_height+gear_pitch_radius+gear_mesh_clearance;
  translate([px+y_rack_center_x-pinion_thickness/2,yy,z])
    rotate([0,90,0])
      rotate([0,0,pinion_angle(yy,-1,pinion_phase_y)]) pinion_gear();
}
module pinion_z(px,py,pz) {
  cx=px+y_dovetail_center_x-y_carriage_w/2;
  translate([cx+z_motor_axis_x_local,py-pinion_thickness/2,
             y_beam_top_z+z_motor_axis_z_local])
    rotate([-90,0,0])
      rotate([0,0,pinion_angle(pz,+1,pinion_phase_z)]) pinion_gear();
}

// As secoes sao invariantes ao longo do curso; extremos ficam guardados por
// assertions e pelo arquivo 96. Testar o centro reduz muito o tempo CSG.
px=(X_MIN+X_MAX)/2;
py=(Y_MIN+Y_MAX)/2;
assert(X_MIN-x_carriage_length/2 >= 0);
assert(X_MAX+x_carriage_length/2 <= x_rail_length);
assert(Y_MIN-z_axis_center_y_local >= 0);
assert(Y_MAX-z_axis_center_y_local+y_carriage_length <= y_rail_length+8);

translate([0,0,0]) intersection() {
  translate([0,front_y,0]) trilho_x_motriz();
  driven(px);
}
translate([400,0,0]) intersection() {
  translate([0,rear_y,0]) trilho_x_passivo();
  shoe(px);
}
for (err=[-passive_float,0,passive_float])
  translate([800,0,0]) intersection() {
    shoe(px,err,-0.02); saddle(px,0.02);
  }
translate([1200,0,0]) intersection() { beam(px); driven(px); }
translate([1600,0,0]) intersection() { beam(px); saddle(px); }
translate([2000,0,0]) intersection() {
  beam(px); translate([0,front_y,0]) trilho_x_motriz();
}
translate([2400,0,0]) intersection() {
  beam(px); translate([0,rear_y,0]) trilho_x_passivo();
}

translate([2800,0,0]) intersection() {
  translate([0,front_y,0]) base_trilho_x(include_rack=false);
  pinion_x(px);
}
translate([3200,0,0]) intersection() { driven(px); pinion_x(px); }
translate([3600,0,0]) intersection() { beam(px); cy(px,py); }
translate([4000,0,0]) intersection() { beam(px,false); pinion_y(px,py); }
translate([4400,0,0]) intersection() { cy(px,py); pinion_y(px,py); }

for (pz=[Z_DOWN,Z_UP]) {
  translate([4800,0,0]) intersection() { cy(px,py); plunger(px,py,pz); }
  translate([5200,0,0]) intersection() { cy(px,py); pinion_z(px,py,pz); }
  translate([5600,0,0]) intersection() {
    plunger(px,py,pz,false); pinion_z(px,py,pz);
  }
  translate([6000,0,0]) intersection() { beam(px,false); pinion_z(px,py,pz); }
}
}

// Elimina residuos coplanares de area zero antes da exportacao STL.
render(convexity=20) run_collision_tests();
