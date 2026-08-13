include <00_Parametros.scad>;
use <01_Base_Trilho_X.scad>;
use <02_Carrinho_X.scad>;
use <03_Trilho_Y.scad>;
use <04_Carrinho_Y.scad>;
use <05_Modulo_Z_Caneta.scad>;
use <06_Pinhoes.scad>;

// Resultado correto: somente um cubo. Qualquer outro solido e colisao.

cx_y_offset = base_w/2 - 28/2;
ty_y_origin = cx_y_offset + 28/2 - y_mount_tongue_d/2 + y_mount_offset_y;
ty_z_offset = base_h + 12;
cy_x_offset = y_dovetail_center_x - 32/2;

motor_x_z = base_h + tooth_height/2 + gear_pitch_radius + gear_mesh_clearance;
motor_y_z = 10 + tooth_height/2 + gear_pitch_radius + gear_mesh_clearance;
pinion_z_x = cy_x_offset + z_motor_axis_x;
pinion_z_z = 10 + z_motor_axis_z;

// Guardas dimensionais: falham na compilacao se um parametro reintroduzir
// as sobreposicoes vistas na montagem animada.
assert(motor_x_z - gear_tip_radius > base_h + 0.2,
       "Pinhao X atravessa a plataforma da cremalheira");
assert(motor_y_z - gear_tip_radius > 10 + 0.2,
       "Pinhao Y atravessa a plataforma da cremalheira");
assert((z_motor_axis_x - z_axis_center_x) - gear_tip_radius
       > z_cage_w/2 + 0.2,
       "Pinhao Z atravessa o montante da gaiola");
assert(y_carriage_length >= motor_flange_dist + 2*wall_screw,
       "Carrinho Y curto para a flange real do 28BYJ-48");

module carriage_x_world(px, dz=0) {
  translate([px, cx_y_offset, base_h + dz]) carrinho_x();
}

module rail_y_world(px, include_rack=true) {
  translate([px + 2, ty_y_origin, ty_z_offset])
    trilho_y(include_rack=include_rack);
}

module mount_key_world(px) {
  translate([px + 2, ty_y_origin, ty_z_offset])
    translate([12, y_mount_tongue_d/2, -y_mount_tongue_h + 0.1])
      y_mount_key();
}

module pinion_x_world(px) {
  translate([px + 14, x_rack_center_y - pinion_thickness/2, motor_x_z])
    rotate([-90, 0, 0]) pinion_gear();
}

module carriage_y_local(py, dz=0) {
  translate([cy_x_offset, py, 10 + dz]) carrinho_y();
}

module pinion_y_local(py) {
  translate([y_rack_center_x - pinion_thickness/2,
             py + y_carriage_length/2, motor_y_z])
    rotate([0, 90, 0]) pinion_gear();
}

module plunger_local(py, pz, include_rack=true) {
  translate([cy_x_offset + z_axis_center_x, py + z_axis_center_y, 8 + pz])
    modulo_z_pen_plunger(include_rack=include_rack);
}

module pinion_z_local(py) {
  translate([pinion_z_x, py + z_axis_center_y + pinion_thickness/2, pinion_z_z])
    rotate([90, 0, 0]) pinion_gear();
}

module run_collision_tests() {
translate([1800, 1000, 0]) cube([1, 1, 1]);

for (px = [X_MIN, (X_MIN + X_MAX)/2, X_MAX]) {
  // Guias deslizantes devem ter folga, nunca intersecao solida.
  translate([0, 0, 0])
    intersection() { base_trilho_x(); carriage_x_world(px, 0.02); }

  // Pinhao X contra estrutura, carrinho e conjunto do trilho Y.
  translate([300, 0, 0])
    intersection() { base_trilho_x(include_rack=false); pinion_x_world(px); }
  translate([600, 0, 0])
    intersection() { carriage_x_world(px); pinion_x_world(px); }
  translate([900, 0, 0])
    intersection() { rail_y_world(px); pinion_x_world(px); }
  translate([1200, 0, 0])
    intersection() { mount_key_world(px); pinion_x_world(px); }

  for (py = [Y_MIN, (Y_MIN + Y_MAX)/2, Y_MAX])
    translate([px + 2, ty_y_origin, ty_z_offset]) {
      translate([0, 300, 0])
        intersection() { trilho_y(); carriage_y_local(py, 0.02); }
      translate([300, 300, 0])
        intersection() { trilho_y(include_rack=false); pinion_y_local(py); }
      translate([600, 300, 0])
        intersection() { carriage_y_local(py); pinion_y_local(py); }

      for (pz = [Z_DOWN, Z_UP]) {
        translate([0, 600, 0])
          intersection() { carriage_y_local(py); plunger_local(py, pz); }
        translate([300, 600, 0])
          intersection() { pinion_y_local(py); plunger_local(py, pz); }
        translate([600, 600, 0])
          intersection() {
            pinion_z_local(py);
            plunger_local(py, pz, include_rack=false);
          }
        translate([900, 600, 0])
          intersection() { pinion_z_local(py); carriage_y_local(py); }
        translate([1200, 600, 0])
          intersection() { pinion_z_local(py); trilho_y(include_rack=false); }
  }
}
}
}

// render() descarta residuos coplanares de area/volume zero antes da exportacao.
render(convexity=20) run_collision_tests();
