/* Teste local rapido dos bolsos e da sapata. Resultado: um cubo marcador. */
include <00_Parametros.scad>;
use <02_Carrinho_X.scad>;
use <04_Carrinho_Y.scad>;
use <05_Modulo_Z_Caneta.scad>;

translate([300,300,0]) cube([1,1,1]);

mxz=rack_pitch_height+gear_pitch_radius+gear_mesh_clearance;
for (a=[0,18,35]) intersection() {
  carrinho_x_motriz();
  translate([x_carriage_length/2,x_rack_center_y-pinion_thickness/2,mxz])
    rotate([-90,0,0]) rotate([0,0,a]) pinion_gear();
}

rack_local_x=y_carriage_w/2+(y_rack_center_x-y_dovetail_center_x);
myz=rack_pitch_height+gear_pitch_radius+gear_mesh_clearance;
for (a=[0,18,35]) translate([80,0,0]) intersection() {
  carrinho_y();
  translate([rack_local_x-pinion_thickness/2,y_carriage_length/2,myz])
    rotate([0,90,0]) rotate([0,0,a]) pinion_gear();
}

for (a=[0,18,35]) translate([160,0,0]) intersection() {
  carrinho_y();
  translate([z_motor_axis_x_local,
             z_axis_center_y_local-pinion_thickness/2,
             z_motor_axis_z_local])
    rotate([-90,0,0]) rotate([0,0,a]) pinion_gear();
}

for (pz=[Z_DOWN,Z_UP]) translate([0,80,0]) intersection() {
  carrinho_y();
  translate([z_axis_center_x_local,z_axis_center_y_local,
             z_plunger_down_z-y_beam_top_z+pz])
    modulo_z_pen_plunger();
}

for (err=[-passive_float,0,passive_float])
  translate([80,80,0]) intersection() {
    translate([0,err,0]) sapata_x_passiva();
    translate([0,0,passive_shoe_h+0.02]) sela_x_passiva();
  }
