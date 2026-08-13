include <00_Parametros.scad>;
use <02_Carrinho_X.scad>;
use <04_Carrinho_Y.scad>;
use <05_Modulo_Z_Caneta.scad>;

// Marcador unico: o STL deve conter exatamente este cubo. Qualquer outro
// componente indica interferencia solida em uma das verificacoes abaixo.
translate([200, 200, 0]) cube([1, 1, 1]);

// Pinhao X versus carrinho X.
intersection() {
  carrinho_x();
  translate([14,
             x_rack_center_y - (base_w/2 - 28/2) - pinion_thickness/2,
             tooth_height/2 + gear_pitch_radius])
    rotate([-90, 0, 0]) pinion_gear();
}

// Pinhao Y versus carrinho Y.
translate([60, 0, 0]) intersection() {
  carrinho_y();
  translate([19.5, y_carriage_length/2, tooth_height/2 + gear_pitch_radius])
    rotate([0, 90, 0]) pinion_gear();
}

// Pinhao Z versus carrinho Y.
translate([120, 0, 0]) intersection() {
  carrinho_y();
  translate([z_motor_axis_x, z_axis_center_y + pinion_thickness/2, z_motor_axis_z])
    rotate([90, 0, 0]) pinion_gear();
}

// Carro Z nos dois extremos do curso versus sua guia fixa.
translate([0, 60, 0]) intersection() {
  carrinho_y();
  translate([z_axis_center_x, z_axis_center_y, -2]) modulo_z_pen_plunger();
}

translate([60, 60, 0]) intersection() {
  carrinho_y();
  translate([z_axis_center_x, z_axis_center_y, -2 + active_z_travel])
    modulo_z_pen_plunger();
}
