include <00_Parametros.scad>;
use <01_Base_Trilho_X.scad>;
use <02_Carrinho_X.scad>;
use <03_Trilho_Y.scad>;
use <04_Carrinho_Y.scad>;
use <05_Modulo_Z_Caneta.scad>;
use <90_Componentes_Referencia.scad>;

// Teste CSG dos envelopes dos motores em centro e extremos de curso.
// Resultado correto: STL contendo somente este cubo de 1 mm.
translate([500, 500, 0]) cube([1, 1, 1]);

cx_y_offset = base_w/2 - 28/2;
ty_y_origin = cx_y_offset + 28/2 - y_mount_tongue_d/2 + y_mount_offset_y;
ty_z_offset = base_h + 12;
cy_x_offset = y_dovetail_center_x - 32/2;

module motor_x_body(px) {
  translate([px + 14,
             cx_y_offset + x_motor_face_y_local,
             base_h + tooth_height/2 + gear_pitch_radius + gear_mesh_clearance])
    rotate([-90, 0, 0]) motor_28byj48_body_envelope();
}

module rail_y_world(px) {
  translate([px + 2, ty_y_origin, ty_z_offset]) trilho_y();
}

module carriage_x_world(px) {
  translate([px, cx_y_offset, base_h]) carrinho_x();
}

module motor_y_body_local(py) {
  translate([cy_x_offset + 32,
             py + y_carriage_length/2,
             10 + tooth_height/2 + gear_pitch_radius + gear_mesh_clearance])
    rotate([0, -90, 0]) motor_28byj48_body_envelope();
}

module motor_z_body_local(py) {
  translate([cy_x_offset + z_motor_axis_x,
             py,
             10 + z_motor_axis_z])
    rotate([-90, 0, 0]) motor_28byj48_body_envelope();
}

module motor_y_body_world(px, py) {
  translate([px + 2, ty_y_origin, ty_z_offset]) motor_y_body_local(py);
}

module motor_z_body_world(px, py) {
  translate([px + 2, ty_y_origin, ty_z_offset]) motor_z_body_local(py);
}

module carriage_y_local(py) {
  translate([cy_x_offset, py, 10]) carrinho_y();
}

module plunger_local(py, pz) {
  translate([cy_x_offset + z_axis_center_x,
             py + z_axis_center_y,
             8 + pz])
    modulo_z_pen_plunger();
}

for (px = [X_MIN, (X_MIN + X_MAX)/2, X_MAX]) {
  // Motor X contra a estrutura fixa e seu suporte.
  intersection() { motor_x_body(px); base_trilho_x(); }
  intersection() { motor_x_body(px); rail_y_world(px); }
  intersection() { motor_x_body(px); carriage_x_world(px); }

  for (py = [Y_MIN, (Y_MIN + Y_MAX)/2, Y_MAX]) {
    // Todos os pares de corpos dos motores.
    intersection() { motor_x_body(px); motor_y_body_world(px, py); }
    intersection() { motor_x_body(px); motor_z_body_world(px, py); }
    translate([px + 2, ty_y_origin, ty_z_offset]) intersection() {
      motor_y_body_local(py); motor_z_body_local(py);
    }

    // Motores Y/Z contra trilho, carrinho e modulo Z nos dois extremos.
    translate([px + 2, ty_y_origin, ty_z_offset]) {
      intersection() { motor_y_body_local(py); trilho_y(); }
      intersection() { motor_z_body_local(py); trilho_y(); }
      intersection() { motor_y_body_local(py); carriage_y_local(py); }
      intersection() { motor_z_body_local(py); carriage_y_local(py); }

      for (pz = [Z_DOWN, Z_UP]) {
        intersection() { motor_y_body_local(py); plunger_local(py, pz); }
        intersection() { motor_z_body_local(py); plunger_local(py, pz); }
      }
    }
  }
}
