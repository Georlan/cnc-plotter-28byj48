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
    - Chaveta separada une dois sockets sem criar balanco na impressao
  
  RESULTADO: 2 componentes no STL (trilho + chaveta)
  
  Orientação de impressão: face traseira (back_plate) no leito, Z=0.
  =============================================================================
*/

include <00_Parametros.scad>;

module trilho_y(length=y_rail_length, include_rack=true) {
  rail_w = y_rail_width;
  rail_h = 10.0;   // Z
  back_h = 3.0;    // Espessura da placa traseira

  dt_x   = y_dovetail_center_x;
  rack_x = y_rack_center_x;

  rib_w  = wall_structural;  // 2.8mm

  dt_platform_w    = dovetail_width_bottom + 1.0;
  dt_platform_h    = 2.5;
  rack_platform_w  = rack_width + 1.0;
  rack_platform_h  = 2.5;

  tongue_w = y_mount_tongue_w;
  tongue_d = y_mount_tongue_d;
  tongue_h = y_mount_tongue_h;

  difference() {
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
      for (cy = [20 : 40 : length - 20]) {
        translate([wall_thin, cy - wall_thin/2, back_h - EPS])
          cube([rail_w - 2*wall_thin, wall_thin, 3.5]);
      }

        // Boss local recebe a metade superior da chaveta.
        translate([dt_x - (tongue_w + 4.0)/2, 0, 0])
          cube([tongue_w + 4.0, tongue_d + 4.0, y_mount_boss_h]);
      }

      // ====== GUIA DOVETAIL MACHO Y (overlap de 0.5mm com plataforma) ======
      color([0.2, 0.6, 0.9])
        translate([dt_x, 0, rail_h - 0.5])
          dovetail_male_y(length=length);

      // ====== CREMALHEIRA Y ======
      if (include_rack)
        color([0.95, 0.85, 0.15])
          translate([rack_x, 0, rail_h])
            rack_y(length=length);
    }

    // Socket inferior do trilho: mantem Z minimo em zero e a face traseira plana.
    translate([dt_x - (tongue_w + 0.4)/2,
               -(EPS), -EPS])
      cube([tongue_w + 0.4, tongue_d + 0.4,
            y_mount_upper_socket_h + EPS]);

    for (sx = y_mount_screw_x)
      translate([sx, y_mount_screw_y, -EPS])
        cylinder(r=1.65, h=y_mount_boss_h + EPS*2);
  }
}

module y_mount_key() {
  translate([-y_mount_tongue_w/2, -y_mount_tongue_d/2, 0])
    cube([y_mount_tongue_w, y_mount_tongue_d, y_mount_key_h]);
}

// Renderização para impressão/exportação
trilho_y();
// Peça avulsa para impressão: manter afastada do trilho alargado de 28 mm.
translate([48, 8, 0]) y_mount_key();
