/*
  =============================================================================
  07_Batentes.scad - Batentes Removíveis Minimalistas (Low-Cost)
  =============================================================================
  Batentes mecânicos enxutos aparafusáveis com 1 único parafuso M3 cada.
  Instalados APÓS a inserção do carrinho no trilho.
*/

include <00_Parametros.scad>;

module batente_removivel_x() {
  difference() {
    cube([5.0, 30.0, dovetail_height + 4.0], center=false);
    translate([2.5, 5.0, 4.0]) rotate([0, 90, 0]) cylinder(r=1.6, h=10, center=true);
  }
}

module batente_removivel_y() {
  difference() {
    cube([24.0, 5.0, dovetail_height + 4.0], center=false);
    translate([5.0, 2.5, 4.0]) rotate([90, 0, 0]) cylinder(r=1.6, h=10, center=true);
  }
}

// Renderização dos batentes dispostos para impressão
translate([0, 0, 0]) batente_removivel_x();
translate([12, 0, 0]) batente_removivel_y();
