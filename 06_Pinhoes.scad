/*
  =============================================================================
  06_Pinhoes.scad - Pinhoes involuta stub para os eixos X, Y e Z
  =============================================================================
  Correções:
    - Dentes involuta stub com angulo de pressao de 30 graus
    - Raizes com sobreposicao volumetrica no cubo, sem efeito transparente no F5
    - Diametro externo nominal = 2 x gear_tip_radius = 14.77 mm
    - D-shaft hole unificado com d_shaft_hole()
    - 3 pinhões separados (X, Y, Z) para impressão individual
  
  Resultado: 3 COMPONENTES INDEPENDENTES no STL (um por pinhao)
  
  Geometria:
    gear_teeth = 10
    rack_pitch = 4.0 mm
    pitch_radius ≈ 6.366 mm  (primitivo)
    root_radius  ≈ 5.093 mm  (raiz)
    tip_radius   ≈ 7.385 mm  (ponta do dente)
    outer_diameter ≈ 14.77 mm (nominal)
  =============================================================================
*/

include <00_Parametros.scad>;

// Renderização dos 3 pinhões dispostos lado a lado para impressão
// Pinhão X
color([1.0, 0.50, 0.08, 1.0])
  translate([0, 0, 0])
    pinion_gear(thickness=pinion_thickness);

// Pinhão Y
color([1.0, 0.50, 0.08, 1.0])
  translate([20, 0, 0])
    pinion_gear(thickness=pinion_thickness);

// Pinhão Z
color([1.0, 0.50, 0.08, 1.0])
  translate([40, 0, 0])
    pinion_gear(thickness=pinion_thickness);
