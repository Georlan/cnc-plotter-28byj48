/*
  =============================================================================
  03_Trilho_Y.scad - Trilho do Eixo Y (GEOMETRIA CORRIGIDA DEFINITIVA)
  =============================================================================
  Perfil Low-Cost com nervuras:
    - Placa traseira contínua
    - Paredes laterais/flanges
    - Nervura central sob dovetail_male_y + plataforma de transição
    - Nervura sob rack_y + plataforma
    - Dovetail e rack integrados com overlap de 0.5mm
    - Tongue (língua) para encaixar no socket do Carrinho X (overlap de 0.5mm)
  
  RESULTADO: 1 ÚNICO COMPONENTE CONECTADO no STL
  
  Orientação de impressão: face traseira (back_plate) no leito, Z=0.
  =============================================================================
*/

include <00_Parametros.scad>;

module trilho_y(length=y_rail_length) {
  rail_w = 24.0;   // X
  rail_h = 10.0;   // Z
  back_h = 3.0;    // Espessura da placa traseira

  dt_x   = rail_w / 2;       // X=12
  rack_x = rail_w - 5.0;     // X=19

  rib_w  = wall_structural;  // 2.8mm

  dt_platform_w    = dovetail_width_bottom + 1.0;
  dt_platform_h    = 2.5;
  rack_platform_w  = rack_width + 1.0;
  rack_platform_h  = 2.5;

  tongue_w = 9.5;
  tongue_d = 9.5;
  tongue_h = 5.5;

  union() {
    // ====== ESTRUTURA PRINCIPAL ======
    color([0.25, 0.28, 0.32]) {
      cube([rail_w, length, back_h]);
      cube([wall_thin, length, rail_h]);
      translate([rail_w - wall_thin, 0, 0])
        cube([wall_thin, length, rail_h]);
      translate([dt_x - rib_w/2, 0, 0])
        cube([rib_w, length, rail_h]);
      translate([dt_x - dt_platform_w/2, 0, rail_h - dt_platform_h])
        cube([dt_platform_w, length, dt_platform_h + EPS]);
      translate([rack_x - rib_w/2, 0, 0])
        cube([rib_w, length, rail_h]);
      translate([rack_x - rack_platform_w/2, 0, rail_h - rack_platform_h])
        cube([rack_platform_w, length, rack_platform_h + EPS]);

      // Nervuras transversais com altura até Z=6.5mm (sem criar bolsas internas fechadas)
      for (cy = [30, length/2, length - 30]) {
        translate([wall_thin, cy - wall_thin/2, back_h - EPS])
          cube([rail_w - 2*wall_thin, wall_thin, 3.5]);
      }

      // Tongue (língua) para encaixe no Carrinho X (Y negativo) com overlap de 0.5mm no corpo
      translate([rail_w/2 - tongue_w/2, -tongue_d, rail_h/2 - tongue_h/2])
        cube([tongue_w, tongue_d + 0.5, tongue_h]);
    }

    // ====== GUIA DOVETAIL MACHO Y (overlap de 0.5mm com plataforma) ======
    color([0.2, 0.6, 0.9])
      translate([dt_x, 0, rail_h - 0.5])
        dovetail_male_y(length=length);

    // ====== CREMALHEIRA Y ======
    color([0.95, 0.85, 0.15])
      translate([rack_x, 0, rail_h])
        rack_y(length=length);
  }
}

// Renderização para impressão/exportação
trilho_y();
