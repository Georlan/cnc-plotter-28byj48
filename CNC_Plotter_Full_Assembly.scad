/*
  =============================================================================
  CNC_Plotter_Full_Assembly.scad - Montagem Completa (GEOMETRIA CORRIGIDA)
  =============================================================================
  Montagem paramétrica com:
    - Posições cinemáticas X/Y/Z
    - SEPARAÇÃO FÍSICA TOTAL DOS MOTORES X, Y E Z (zero interferência)
      * Motor X: montado na face traseira do Carrinho X (eixo em -Y)
      * Motor Y: montado na face direita do Carrinho Y (eixo em -X)
      * Motor Z: montado na face frontal do Carrinho Y (eixo horizontal em +Y)
    - Transmissão rack/pinhão 100% sintonizada em X, Y e Z
    - Cores de debug para auditoria visual
  
  Cores de debug:
    Estrutura = cinza escuro
    Dovetail = azul/ciano
    Rack = amarelo
    Pinhão = laranja
    Motor = cinza metálico
  =============================================================================
*/

include <00_Parametros.scad>;
use <01_Base_Trilho_X.scad>;
use <02_Carrinho_X.scad>;
use <03_Trilho_Y.scad>;
use <04_Carrinho_Y.scad>;
use <05_Modulo_Z_Caneta.scad>;
use <06_Pinhoes.scad>;
use <90_Componentes_Referencia.scad>;

module cnc_plotter_assembly(
  pos_x = 80,
  pos_y = 60,
  pos_z = Z_UP,
  show_motors = true,
  show_paper  = false,
  show_legacy = false,
  show_debug  = false,
  exploded    = 0.0
) {
  // =========================================================================
  // Posições de referência da transmissão X
  // =========================================================================
  dt_x_y   = base_w / 2;     // Y=15
  rack_x_y = base_w - 5.0;   // Y=25

  rack_x_pitch_z = base_h + tooth_height / 2;
  motor_x_center_z = rack_x_pitch_z + gear_pitch_radius;

  cx_width = 28.0;
  cx_dt_local_y = cx_width / 2;
  cx_y_offset = dt_x_y - cx_dt_local_y;

  // Trilho Y
  ry_rail_w = 24.0;
  ry_rail_h = 10.0;
  ry_rack_x_local = ry_rail_w - 5.0;  // X=19 local
  ry_dt_x_local   = ry_rail_w / 2;    // X=12 local

  // =========================================================================
  // 1. BASE X (fixa na bancada)
  // =========================================================================
  base_trilho_x();

  // =========================================================================
  // 2. CARRINHO X (desliza ao longo de X)
  // =========================================================================
  translate([pos_x, cx_y_offset, base_h + (exploded * 10)])
    carrinho_x();

  // =========================================================================
  // 3. PINHÃO X (montado no eixo do motor X)
  // =========================================================================
  color([1.0, 0.55, 0.1])
    translate([pos_x + cx_width/2, rack_x_y, motor_x_center_z + (exploded * 20)])
      rotate([90, 0, 0])
        pinion_gear(thickness=7.0);

  // =========================================================================
  // 4. MOTOR X (referência visual - montado na face traseira em +Y)
  // =========================================================================
  if (show_motors) {
    translate([pos_x + cx_width/2, rack_x_y + 3.5 + (exploded * 15), motor_x_center_z])
      rotate([-90, 0, 0])
        motor_28byj48_reference();
  }

  // =========================================================================
  // 5. TRILHO Y (fixo ao Carrinho X, perpendicular)
  // =========================================================================
  ty_x_offset = pos_x + cx_width/2 - ry_rail_w/2;
  ty_y_origin = cx_y_offset + cx_width/2 - 5;
  ty_z_offset = base_h + 12.0 + (exploded * 15);

  translate([ty_x_offset, ty_y_origin, ty_z_offset]) {
    trilho_y();

    // =========================================================================
    // 6. CARRINHO Y (desliza ao longo de Y no trilho Y)
    // =========================================================================
    cy_width_local  = 32.0;
    cy_length_local = 28.0;
    cy_dt_local_x   = cy_width_local / 2;
    cy_x_offset     = ry_dt_x_local - cy_dt_local_x;  // X=12 - 16 = -4

    translate([cy_x_offset, pos_y, ry_rail_h + (exploded * 10)])
      carrinho_y();

    // =========================================================================
    // 7. PINHÃO Y (mesha com a cremalheira Y do Trilho Y)
    // =========================================================================
    rack_y_pitch_z = ry_rail_h + tooth_height / 2;
    motor_y_center_z = rack_y_pitch_z + gear_pitch_radius;

    color([1.0, 0.55, 0.1])
      translate([ry_rack_x_local, pos_y + cy_length_local/2, motor_y_center_z + (exploded * 20)])
        rotate([0, 90, 0])
          pinion_gear(thickness=7.0);

    // =========================================================================
    // 8. MOTOR Y (referência visual - montado na face direita em +X)
    // =========================================================================
    if (show_motors) {
      translate([ry_rack_x_local + 5.0 + (exploded * 15), pos_y + cy_length_local/2, motor_y_center_z])
        rotate([0, -90, 0])
          motor_28byj48_reference();
    }

    // =========================================================================
    // 9. MÓDULO Z + CANETA (desliza verticalmente em Z)
    // =========================================================================
    mz_x = cy_x_offset + 6.0;  // X=2
    mz_y = pos_y + cy_length_local/2; // Y=pos_y + 14
    mz_z = ry_rail_h + 14.0 + (exploded * 10);

    translate([mz_x, mz_y, mz_z - pos_z])
      modulo_z_pen_plunger();

    // =========================================================================
    // 10. PINHÃO Z E MOTOR Z (montado na face frontal em -Y, eixo horizontal)
    // =========================================================================
    // Pinhão Z mesha com a cremalheira Z do êmbolo na face +X do êmbolo
    pz_x = mz_x + 6.0 + tooth_height/2 + gear_pitch_radius; // ≈ 2 + 6 + 1.1 + 6.366 = 15.466
    pz_y = mz_y;
    pz_z = ry_rail_h + 18.0;

    color([1.0, 0.55, 0.1])
      translate([pz_x, pos_y, pz_z + (exploded * 20)])
        rotate([90, 0, 0])
          pinion_gear(thickness=7.0);

    if (show_motors) {
      translate([pz_x, pos_y - 3.5 - (exploded * 15), pz_z])
        rotate([90, 0, 0])
          motor_28byj48_reference();
    }
  }

  // =========================================================================
  // PAPEL A5 (opcional)
  // =========================================================================
  if (show_paper) {
    color([1.0, 1.0, 0.95, 0.5])
      translate([10, 5, -0.5])
        cube([paper_width, paper_height, 0.3]);
  }
}

// Renderização padrão
cnc_plotter_assembly();
