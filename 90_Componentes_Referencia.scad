/*
  =============================================================================
  90_Componentes_Referencia.scad - Modelos Visuais de Referência
  =============================================================================
  Modelos simplificados não-imprimíveis para visualização na montagem.
  Usa d_shaft_solid() unificado para o eixo D do motor.
  =============================================================================
*/

include <00_Parametros.scad>;

module motor_28byj48_reference() {
  // Corpo cilíndrico do motor
  color([0.7, 0.7, 0.72])
    cylinder(r=motor_body_r, h=motor_body_h);

  // Boss de saída do eixo
  color([0.65, 0.65, 0.68])
    translate([0, 0, motor_body_h])
      cylinder(r=motor_boss_r, h=motor_boss_h);

  // Eixo D (usando módulo unificado)
  color([0.8, 0.8, 0.85])
    translate([0, 0, motor_body_h + motor_boss_h])
      d_shaft_solid(h=motor_shaft_length);

  // Furos de montagem (flanges laterais)
  color([0.6, 0.6, 0.63])
  for (dx = [-motor_flange_dist/2, motor_flange_dist/2]) {
    translate([dx, 0, 0])
      difference() {
        cylinder(r=3.5, h=1.0);
        translate([0, 0, -EPS])
          cylinder(r=motor_flange_hole_r, h=1.0 + EPS*2);
      }
  }
}

module driver_uln2003_reference() {
  color([0.15, 0.35, 0.15])
    cube([35, 32, 1.6], center=false);
  // Conector
  color([0.9, 0.9, 0.9])
    translate([2, 10, 1.6])
      cube([8, 12, 8]);
}

// Teste visual isolado
motor_28byj48_reference();
translate([40, 0, 0]) driver_uln2003_reference();
