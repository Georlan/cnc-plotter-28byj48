/*
  =============================================================================
  04_Carrinho_Y.scad - Carrinho do Eixo Y (GEOMETRIA CORRIGIDA DEFINITIVA)
  =============================================================================
  Correções de Engenharia Mecânica:
    - Motor Y: montado na face direita (+X) com eixo horizontal (-X) acionando Rack Y.
    - Motor Z: montado na face frontal (-Y) com eixo horizontal (+Y) acionando Rack Z do êmbolo.
    - SEPARAÇÃO TOTAL MOTOR Y vs MOTOR Z (zero colisão / zero sobreposição).
    - Canal dovetail_female_y no fundo.
    - Guia da caneta (Modulo Z) no lado esquerdo.
    - 1 ÚNICO COMPONENTE CONECTADO no STL.
  
  Orientação de impressão: fundo do carrinho no leito (Z=0).
  =============================================================================
*/

include <00_Parametros.scad>;

module carrinho_y() {
  // Dimensões do corpo principal
  cy_width   = 32.0;  // X (largura transversal)
  cy_length  = 28.0;  // Y (comprimento ao longo do trilho Y)
  cy_height  = 14.0;  // Z (altura total)

  // Centro do canal dovetail no eixo X
  dt_local_x = cy_width / 2;  // X=16

  // Motor Y: eixo horizontal em -X (face direita +X)
  motor_y_z_local = tooth_height / 2 + gear_pitch_radius;  // ≈7.466mm
  motor_y_x_local = cy_width;
  hole_y_front     = cy_length/2 - motor_flange_dist/2;   // -3.5
  hole_y_back      = cy_length/2 + motor_flange_dist/2;    // 31.5

  // Motor Z: eixo horizontal em +Y (face frontal -Y)
  // Posicionado para o pinhão Z engrenar com a cremalheira Z do êmbolo
  // Êmbolo centro em X=6, Y=cy_length/2. Rack Z no êmbolo fica em X ≈ 6 + 1.1 = 7.1mm
  // Pinhão Z centro em X = 7.1 + 6.366 = 13.466mm
  motor_z_x_local = 13.5;
  motor_z_z_local = 18.0; // Altura do eixo Z
  hole_z_left     = motor_z_x_local - motor_flange_dist/2;  // -4.0
  hole_z_right    = motor_z_x_local + motor_flange_dist/2;  // 31.0

  // Guia da caneta (furo passante vertical em X=6.0, Y=cy_length/2)
  pen_bore_r = (pen_diameter + pen_clearance * 2) / 2;

  difference() {
    union() {
      color([0.35, 0.42, 0.48]) {
        // ====== CORPO PRINCIPAL ======
        cube([cy_width, cy_length, cy_height]);

        // ====== ORELHAS DE MONTAGEM DO MOTOR Y (face +X) ======
        // Orelha frontal
        hull() {
          translate([motor_y_x_local, hole_y_front, motor_y_z_local])
            rotate([0, 90, 0])
              cylinder(r=wall_screw, h=3.0);
          translate([motor_y_x_local, 0, motor_y_z_local])
            rotate([0, 90, 0])
              cylinder(r=wall_screw, h=3.0);
        }
        // Orelha traseira
        hull() {
          translate([motor_y_x_local, hole_y_back, motor_y_z_local])
            rotate([0, 90, 0])
              cylinder(r=wall_screw, h=3.0);
          translate([motor_y_x_local, cy_length, motor_y_z_local])
            rotate([0, 90, 0])
              cylinder(r=wall_screw, h=3.0);
        }

        // ====== ORELHAS DE MONTAGEM DO MOTOR Z (face -Y) ======
        // Orelha esquerda
        hull() {
          translate([hole_z_left, 0, motor_z_z_local])
            rotate([-90, 0, 0])
              cylinder(r=wall_screw, h=3.0);
          translate([0, 0, motor_z_z_local])
            rotate([-90, 0, 0])
              cylinder(r=wall_screw, h=3.0);
        }
        // Orelha direita
        hull() {
          translate([hole_z_right, 0, motor_z_z_local])
            rotate([-90, 0, 0])
              cylinder(r=wall_screw, h=3.0);
          translate([cy_width, 0, motor_z_z_local])
            rotate([-90, 0, 0])
              cylinder(r=wall_screw, h=3.0);
        }
      }
    }

    // ====== CANAL DOVETAIL FÊMEA Y (corte no fundo) ======
    translate([dt_local_x, 0, 0])
      dovetail_female_y(length=cy_length);

    // ====== FUROS M3 MOTOR Y ======
    translate([motor_y_x_local - EPS, hole_y_front, motor_y_z_local])
      rotate([0, 90, 0])
        cylinder(r=motor_flange_hole_r, h=20);

    translate([motor_y_x_local - EPS, hole_y_back, motor_y_z_local])
      rotate([0, 90, 0])
        cylinder(r=motor_flange_hole_r, h=20);

    // ====== FUROS M3 MOTOR Z ======
    translate([hole_z_left, -10.0, motor_z_z_local])
      rotate([-90, 0, 0])
        cylinder(r=motor_flange_hole_r, h=20);

    translate([hole_z_right, -10.0, motor_z_z_local])
      rotate([-90, 0, 0])
        cylinder(r=motor_flange_hole_r, h=20);

    // ====== FURO PASSANTE PARA A CANETA (eixo vertical) ======
    translate([6.0, cy_length/2, -EPS])
      cylinder(r=pen_bore_r, h=cy_height + EPS*2);
  }
}

// Renderização para impressão/exportação
carrinho_y();
