/*
  =============================================================================
  08_Clips_Fixacao_Papel.scad - Clips de Fixação Rápida de Papel A5 (R$ 0,00)
  =============================================================================
  Peças impressas ultraleves (4x) para prender o papel A5 firmemente na mesa/MDF.
  Evita que o papel deslize, dobre ou saia do lugar durante a escrita/desenho.
  Possui marcador fiducial de canto (L-shape) para referência óptica de visão.
*/

include <00_Parametros.scad>;

module clip_fixacao_papel() {
  clip_w = 20.0;
  clip_l = 25.0;
  clip_h = 4.0;

  difference() {
    union() {
      // Base plana do clip
      cube([clip_w, clip_l, clip_h], center=false);

      // Aba superior flexível de pressão sobre o papel
      translate([0, 10.0, clip_h])
        rotate([-5, 0, 0])
          cube([clip_w, 15.0, 1.8], center=false);

      // Canto de alinhamento L-shape para papel A5
      translate([0, 0, clip_h])
        cube([2.5, clip_l, 3.0], center=false);
      translate([0, 0, clip_h])
        cube([clip_w, 2.5, 3.0], center=false);
    }

    // Furo para fixação por parafuso M3/M4 ou fita na bancada
    translate([clip_w/2, 5.0, -EPS])
      cylinder(r=1.8, h=clip_h + 4.0, center=false);

    // Entrada autoportante: face inferior a 45 graus, adequada a FDM sem suporte.
    translate([-EPS, 12.0, clip_h - 1.0])
      rotate([45, 0, 0])
        cube([clip_w + (EPS * 2), 10.0, 4.0], center=false);
  }
}

module conjunto_4x_clips_papel() {
  translate([0, 0, 0])   clip_fixacao_papel();
  translate([25, 0, 0])  clip_fixacao_papel();
  translate([50, 0, 0])  clip_fixacao_papel();
  translate([75, 0, 0])  clip_fixacao_papel();
}

// Renderiza os 4 clips de papel para impressão FDM
conjunto_4x_clips_papel();
