/*
  =============================================================================
  01_Base_Trilho_X.scad - Trilho Base Fixo X (GEOMETRIA CORRIGIDA DEFINITIVA)
  =============================================================================
  Perfil Low-Cost com nervuras:
    - Piso contínuo (floor_h = 3mm)
    - Paredes laterais (wall_thin)
    - Nervura central sob dovetail + plataforma de transição
    - Nervura sob cremalheira + plataforma
    - Nervuras transversais periódicas para rigidez torcional
    - Dovetail macho integrado com overlap 0.5mm
    - Cremalheira X integrada com overlap 0.6mm
    - Furos M4 no piso entre nervuras
  
  RESULTADO: 1 ÚNICO COMPONENTE CONECTADO no STL
  
  Orientação de impressão: Z=0 no leito, fundo plano, sem suporte obrigatório.
  =============================================================================
*/

include <00_Parametros.scad>;

module base_trilho_x(length=x_rail_length, include_rack=true) {
  dt_y   = base_w / 2;         // Y=15: centro do dovetail
  rack_y = x_rack_center_y;    // Y=5: cremalheira na face frontal
  rib_w  = wall_structural;    // 2.8mm largura das nervuras

  dt_platform_w    = dovetail_width_bottom + 1.0; // 10.5mm
  dt_platform_h    = 2.5;

  rack_platform_w  = rack_width + 1.0; // 5.0mm
  rack_platform_h  = 2.5;

  difference() {
    union() {
      // ====== ESTRUTURA PRINCIPAL ======
      color([0.25, 0.28, 0.32]) {
        cube([length, base_w, floor_h]);
        cube([length, wall_thin, base_h]);
        translate([0, base_w - wall_thin, 0])
          cube([length, wall_thin, base_h]);
        translate([0, dt_y - rib_w/2, 0])
          cube([length, rib_w, base_h]);
        translate([0, dt_y - dt_platform_w/2, base_h - dt_platform_h])
          cube([length, dt_platform_w, dt_platform_h + EPS]);
        translate([0, rack_y - rib_w/2, 0])
          cube([length, rib_w, base_h]);
        translate([0, rack_y - rack_platform_w/2, base_h - rack_platform_h])
          cube([length, rack_platform_w, rack_platform_h + EPS]);

        // Cinco diafragmas curtos aumentam a rigidez torcional com pouco material.
        for (cx = [20 : 40 : length - 20]) {
          translate([cx - wall_thin/2, wall_thin, floor_h - EPS])
            cube([wall_thin, base_w - 2*wall_thin, base_h - floor_h + EPS]);
        }
      }

      // ====== GUIA DOVETAIL MACHO ======
      // Overlap: afundado 0.5mm na plataforma para união sólida garantida
      color([0.2, 0.6, 0.9])
        translate([0, dt_y, base_h - 0.5])
          dovetail_male_x(length=length);

      // ====== CREMALHEIRA X ======
      // Overlap: base de 0.6mm afundada na plataforma
      if (include_rack)
        color([0.95, 0.85, 0.15])
          translate([0, rack_y, base_h])
            rack_x(length=length);
    }

    // ====== FUROS M4 PARA FIXAÇÃO NA BANCADA ======
    for (fx = [20, length/2, length - 20]) {
      translate([fx, 7.0, -EPS])
        cylinder(r=2.1, h=floor_h + EPS*2);
    }
  }
}

// Renderização para impressão/exportação
base_trilho_x();
