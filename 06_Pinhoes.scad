/*
  =============================================================================
  06_Pinhoes.scad - Engrenagens Pinhão (GEOMETRIA CORRIGIDA DEFINITIVA)
  =============================================================================
  Correções:
    - Dentes trapezoiodais que ultrapassam o pitch circle (addendum correto)
    - Diâmetro externo REAL do STL ≈ 2 × gear_tip_radius ≈ 15.15mm
    - D-shaft hole unificado com d_shaft_hole()
    - 3 pinhões separados (X, Y, Z) para impressão individual
  
  Resultado: 3 COMPONENTES CONECTADOS no STL (um por pinhão)
  
  Geometria:
    gear_teeth = 10
    rack_pitch = 4.0 mm
    pitch_radius ≈ 6.366 mm  (primitivo)
    root_radius  ≈ 5.155 mm  (raiz)
    tip_radius   ≈ 7.577 mm  (ponta do dente)
    outer_diameter ≈ 15.15 mm (medido do STL)
  =============================================================================
*/

include <00_Parametros.scad>;

// Renderização dos 3 pinhões dispostos lado a lado para impressão
// Pinhão X
color([1.0, 0.55, 0.1])
  translate([0, 0, 0])
    pinion_gear(thickness=pinion_thickness);

// Pinhão Y
color([1.0, 0.55, 0.1])
  translate([20, 0, 0])
    pinion_gear(thickness=pinion_thickness);

// Pinhão Z
color([1.0, 0.55, 0.1])
  translate([40, 0, 0])
    pinion_gear(thickness=pinion_thickness);
