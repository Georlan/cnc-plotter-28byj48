/*
  Batentes removiveis de pressao. Imprimir em PETG.
  Quatro unidades X (duas por trilho) e duas unidades Y. Nao usam parafuso;
  a folga de 0,10 mm deve ser confirmada no cupom antes da impressao final.
*/

include <00_Parametros.scad>;

module batente_x() {
  difference() {
    translate([0,-(dovetail_width_top+4)/2,0])
      cube([6,dovetail_width_top+4,dovetail_height+2.2]);
    translate([0,0,-0.35])
      dovetail_female_x(6,clearance=0.10);
    // Rasgo inferior permite pequena flexao ao pressionar no fim do trilho.
    translate([-EPS,-0.6,-EPS]) cube([6+2*EPS,1.2,2.2]);
  }
}

module batente_y() {
  difference() {
    translate([-(dovetail_width_top+4)/2,0,0])
      cube([dovetail_width_top+4,6,dovetail_height+2.2]);
    translate([0,0,-0.35])
      dovetail_female_y(6,clearance=0.10);
    translate([-0.6,-EPS,-EPS]) cube([1.2,6+2*EPS,2.2]);
  }
}

for (i=[0:3]) translate([i*24,0,0]) batente_x();
for (i=[0:1]) translate([i*24,24,0]) batente_y();
