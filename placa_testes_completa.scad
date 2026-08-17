/*
  =============================================================================
  placa_testes_completa.scad - Placa Única com TODOS os Testes da CNC
  =============================================================================
  Organiza todos os cupons físicos de teste em uma única placa 100% plana em Z=0:
    1. Cremalheira curta (Rack)
    2. Dois Pinhões com furo em D
    3. Anel de Folga Radial do motor
    4. Garfo de Folga Axial do bolso
    5. Mandril Universal Z (com chanfro autoportante a 45° nas orelhas)
    6. Três Buchas Redutoras (7.5, 10.0, 12.5 mm)
  =============================================================================
*/

include <00_Parametros.scad>;
use <05_Modulo_Z_Caneta.scad>;

// 1. Cremalheira Curta
translate([0, 0, 0]) {
  union() {
    cube([36, 8, 2.0]);
    translate([2, 4, 2.0]) rack_x(32);
  }
}

// 2. Dois Pinhões D
translate([48, 10, 0]) pinion_gear();
translate([70, 10, 0]) pinion_gear();

// 3. Anel de Folga Radial
translate([10, 24, 0]) {
  difference() {
    cylinder(r=gear_outer_radius + pinion_pocket_radial_clearance + 2.4, h=4.0);
    translate([0,0,-EPS])
      cylinder(r=gear_outer_radius + pinion_pocket_radial_clearance, h=4.0+2*EPS);
  }
}

// 4. Garfo de Folga Axial
translate([32, 22, 0]) {
  base_w = 18; base_d = 12; wall_h = 10; wall_t = 2.4;
  axial_gap = pinion_thickness + 2*pinion_pocket_axial_clearance;
  union() {
    cube([base_w, base_d, 2]);
    cube([wall_t, base_d, wall_h]);
    translate([wall_t + axial_gap, 0, 0]) cube([wall_t, base_d, wall_h]);
  }
}

// 5. Mandril Universal Z
translate([72, 36, tool_holder_height + tool_holder_top_gap])
  z_universal_tool_carrier(include_stem=false);

// 6. Três Buchas Redutoras
for (i = [0 : len(tool_sleeve_sizes)-1]) {
  translate([10 + i * 20, 50, 0])
    z_tool_reducer_sleeve(tool_sleeve_sizes[i]);
}
