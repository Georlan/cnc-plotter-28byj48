/*
  Teste dos tres 28BYJ-48 em centro e extremos.

  Sao verificados separadamente:
    - corpo + chapa de flange, que devem ficar fora das pecas impressas;
    - ressalto + eixo, que so podem atravessar os corredores coaxiais;
    - interferencias entre os tres motores durante o curso.

  Resultado correto: somente o cubo marcador em [800,800,0].
*/

include <00_Parametros.scad>;
use <01_Base_Trilho_X.scad>;
use <02_Carrinho_X.scad>;
use <03_Trilho_Y.scad>;
use <04_Carrinho_Y.scad>;
use <05_Modulo_Z_Caneta.scad>;
use <90_Componentes_Referencia.scad>;

translate([800,800,0]) cube([1,1,1]);

front_y=-base_w/2;
rear_y=x_rail_spacing-base_w/2;
test_clearance=0.05;

module motor_x_back(px) {
  z=base_h+rack_pitch_height+gear_pitch_radius+gear_mesh_clearance;
  translate([px,front_y-motor_x_mount_standoff,z])
    orient_motor_x()
      motor_28byj48_back_envelope(clearance=test_clearance);
}
module motor_x_output(px) {
  z=base_h+rack_pitch_height+gear_pitch_radius+gear_mesh_clearance;
  translate([px,front_y-motor_x_mount_standoff,z])
    orient_motor_x()
      motor_28byj48_output_envelope(clearance=test_clearance);
}
module motor_y_back(px,py) {
  cx=px+y_dovetail_center_x-y_carriage_w/2;
  cy=py-z_axis_center_y_local;
  z=y_beam_top_z+rack_pitch_height+gear_pitch_radius+gear_mesh_clearance;
  translate([cx+y_carriage_w,cy+y_carriage_length/2,z])
    orient_motor_y()
      motor_28byj48_back_envelope(clearance=test_clearance);
}
module motor_y_output(px,py) {
  cx=px+y_dovetail_center_x-y_carriage_w/2;
  cy=py-z_axis_center_y_local;
  z=y_beam_top_z+rack_pitch_height+gear_pitch_radius+gear_mesh_clearance;
  translate([cx+y_carriage_w,cy+y_carriage_length/2,z])
    orient_motor_y()
      motor_28byj48_output_envelope(clearance=test_clearance);
}
module motor_z_back(px,py) {
  cx=px+y_dovetail_center_x-y_carriage_w/2;
  cy=py-z_axis_center_y_local;
  translate([cx+z_motor_axis_x_local,cy,
             y_beam_top_z+z_motor_axis_z_local])
    orient_motor_z()
      motor_28byj48_back_envelope(clearance=test_clearance);
}
module motor_z_output(px,py) {
  cx=px+y_dovetail_center_x-y_carriage_w/2;
  cy=py-z_axis_center_y_local;
  translate([cx+z_motor_axis_x_local,cy,
             y_beam_top_z+z_motor_axis_z_local])
    orient_motor_z()
      motor_28byj48_output_envelope(clearance=test_clearance);
}
module beam(px) translate([px,0,y_beam_bottom_z]) trilho_y();
module driven(px)
  translate([px-x_carriage_length/2,front_y,base_h]) carrinho_x_motriz();
module cy(px,py)
  translate([px+y_dovetail_center_x-y_carriage_w/2,
             py-z_axis_center_y_local,y_beam_top_z]) carrinho_y();
module plunger(px,py,pz)
  translate([px+y_dovetail_center_x-y_carriage_w/2+z_axis_center_x_local,
             py,z_plunger_down_z+pz]) modulo_z_pen_plunger();

px=(X_MIN+X_MAX)/2;
assert(X_MIN-x_carriage_length/2 >= 0);
assert(X_MAX+x_carriage_length/2 <= x_rail_length);
assert(motor_mount_clearance > test_clearance,
       "Folga do corredor do motor menor que o envelope de teste");
module run_motor_tests() {
  intersection() { motor_x_back(px); translate([0,front_y,0]) trilho_x_motriz(); }
  intersection() { motor_x_back(px); driven(px); }
  intersection() { motor_x_back(px); beam(px); }
  intersection() { motor_x_output(px); translate([0,front_y,0]) trilho_x_motriz(); }
  intersection() { motor_x_output(px); driven(px); }
  intersection() { motor_x_output(px); beam(px); }

  for (py=[Y_MIN,(Y_MIN+Y_MAX)/2,Y_MAX]) {
    intersection() { motor_x_back(px); motor_y_back(px,py); }
    intersection() { motor_x_back(px); motor_z_back(px,py); }
    intersection() { motor_y_back(px,py); motor_z_back(px,py); }
    intersection() { motor_y_back(px,py); motor_z_output(px,py); }
    intersection() { motor_y_output(px,py); motor_z_back(px,py); }

    intersection() { motor_y_back(px,py); beam(px); }
    intersection() { motor_z_back(px,py); beam(px); }
    intersection() { motor_y_back(px,py); cy(px,py); }
    intersection() { motor_z_back(px,py); cy(px,py); }
    intersection() { motor_y_output(px,py); beam(px); }
    intersection() { motor_z_output(px,py); beam(px); }
    intersection() { motor_y_output(px,py); cy(px,py); }
    intersection() { motor_z_output(px,py); cy(px,py); }

    for (pz=[Z_DOWN,Z_UP]) {
      intersection() { motor_y_back(px,py); plunger(px,py,pz); }
      intersection() { motor_z_back(px,py); plunger(px,py,pz); }
      intersection() { motor_y_output(px,py); plunger(px,py,pz); }
      intersection() { motor_z_output(px,py); plunger(px,py,pz); }
    }
  }
}

render(convexity=20) run_motor_tests();
