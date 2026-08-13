/*
  =============================================================================
  05_Modulo_Z_Caneta.scad - Carro Z com caneta complacente
  =============================================================================
  Duas pecas imprimiveis:
    1. Carro Z retangular anti-rotacao, acionado pela cremalheira.
    2. Colar bipartido que prende a caneta com um parafuso M3.

  A caneta desliza dentro do carro. Uma mola de compressao ao redor da caneta,
  entre o colar e a ponte superior, fornece 1mm de pre-carga e 3mm de curso
  complacente. Assim o motor posiciona o carro, mas a mola define a pressao no
  papel. Nao ha cavidade coaxial menor que o proprio furo da caneta.

  Orientacao: ambas as pecas com Z=0 no leito. Sem suporte obrigatorio; a ponte
  superior exige apenas uma ponte FDM curta (~13mm).
  =============================================================================
*/

include <00_Parametros.scad>;

z_collar_od = 13.0;
z_collar_h  = 4.0;
z_cage_w    = 20.4;
z_cage_d    = 14.0;
z_post_w    = 3.5;
z_cap_h     = 3.0;
z_cap_bottom = z_carriage_body_h + z_collar_h + spring_length - spring_preload;

module modulo_z_pen_plunger() {
  pen_r = pen_diameter/2 + pen_clearance;

  difference() {
    union() {
      // Guia longa e retangular: duas faces controlam o jogo e impedem giro.
      translate([-z_carriage_w/2, -z_carriage_d/2, 0])
        cube([z_carriage_w, z_carriage_d, z_carriage_body_h]);

      // Dois montantes externos deixam colar e mola visiveis/acessiveis.
      for (sx = [-1, 1]) {
        translate([
          sx < 0 ? -z_cage_w/2 : z_cage_w/2 - z_post_w,
          -z_cage_d/2,
          z_carriage_body_h - EPS
        ])
          cube([z_post_w, z_cage_d, z_cap_bottom - z_carriage_body_h + EPS]);
      }

      // Ponte que comprime a mola. O furo central deixa a caneta atravessar.
      translate([-z_cage_w/2, -z_cage_d/2, z_cap_bottom])
        cube([z_cage_w, z_cage_d, z_cap_h]);

      // Rack Z no lado +X, com faixa suficiente para todo o curso ativo.
      translate([z_carriage_w/2 - 0.5, 0, z_rack_start])
        rack_z(length=z_rack_length, width=rack_width);
    }

    // A caneta corre livre no corpo e atravessa a ponte superior.
    translate([0, 0, -EPS])
      cylinder(r=pen_r, h=z_cap_bottom + z_cap_h + EPS*2);
  }
}

module z_pen_collar() {
  collar_pen_r = pen_diameter/2 + 0.05;
  slit_w = 1.0;

  difference() {
    union() {
      cylinder(r=z_collar_od/2, h=z_collar_h);

      // Orelhas do clamp abertas para +Y; nao raspam nos montantes X.
      translate([-4.0, 4.0, 0]) cube([3.5, 6.0, z_collar_h]);
      translate([ 0.5, 4.0, 0]) cube([3.5, 6.0, z_collar_h]);
    }

    translate([0, 0, -EPS])
      cylinder(r=collar_pen_r, h=z_collar_h + EPS*2);

    // Rasgo que permite fechar o colar sobre canetas com pequena variacao.
    translate([-slit_w/2, 0, -EPS])
      cube([slit_w, 11.0, z_collar_h + EPS*2]);

    // Parafuso M3 transversal; pode usar porca M3 ou rosca direta no PLA.
    translate([-6.0, 7.0, z_collar_h/2])
      rotate([0, 90, 0])
        cylinder(r=1.6, h=12.0);
  }
}

// Referencia visual, nao incluida no STL isolado.
module z_compression_spring_reference(compression=0) {
  spring_h = spring_length - spring_preload - compression;
  color([0.75, 0.75, 0.78, 0.65])
    difference() {
      cylinder(r=spring_outer_diameter/2, h=spring_h);
      translate([0, 0, -EPS])
        cylinder(r=spring_inner_diameter/2, h=spring_h + EPS*2);
    }
}

module modulo_z_pen_assembly(compression=0) {
  modulo_z_pen_plunger();
  translate([0, 0, z_carriage_body_h + compression])
    z_pen_collar();
  translate([0, 0, z_carriage_body_h + z_collar_h + compression])
    z_compression_spring_reference(compression=compression);
}

// Arquivo de impressao: carro e colar separados no leito.
modulo_z_pen_plunger();
translate([32, 0, 0]) z_pen_collar();
