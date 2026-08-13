/*
  =============================================================================
  90_Componentes_Referencia.scad - Modelos Visuais de Referência
  =============================================================================
  Modelos simplificados não-imprimíveis para visualização na montagem.
  Usa d_shaft_solid() unificado para o eixo D do motor.
  =============================================================================
*/

include <00_Parametros.scad>;

// Envelope usado pelos testes de interferencia. Mantem apenas o corpo do
// motor: eixo, boss e flanges sao excluidos porque atravessam intencionalmente
// a placa de montagem e o pinhao.
module motor_28byj48_body_envelope(clearance=0, face_relief=0.05) {
  translate([0, 0, -motor_body_h - clearance])
    cylinder(r=motor_body_r + clearance,
             h=motor_body_h + clearance - face_relief);
}

module motor_28byj48_reference() {
  // A face de montagem/saida e Z=0. O corpo fica em Z negativo e o eixo
  // aponta para Z positivo, como no motor real. Isso torna a montagem inequivoca.
  color([0.7, 0.7, 0.72])
    translate([0, 0, -motor_body_h])
      cylinder(r=motor_body_r, h=motor_body_h);

  // Boss de saída do eixo
  color([0.65, 0.65, 0.68])
    translate([0, 0, 0])
      cylinder(r=motor_boss_r, h=motor_boss_h);

  // Eixo D (usando módulo unificado)
  color([0.8, 0.8, 0.85])
    translate([0, 0, motor_boss_h])
      d_shaft_solid(h=motor_shaft_length);

  // Furos de montagem (flanges laterais)
  color([0.6, 0.6, 0.63])
  for (dx = [-motor_flange_dist/2, motor_flange_dist/2]) {
    translate([dx, 0, -1.0])
      difference() {
        cylinder(r=3.5, h=1.0);
        translate([0, 0, -EPS])
          cylinder(r=motor_flange_hole_r, h=1.0 + EPS*2);
      }
  }
}

module m3_screw_reference(length=8.0) {
  color([0.72, 0.74, 0.78]) {
    translate([0, 0, -length/2]) cylinder(r=1.45, h=length);
    translate([0, 0, length/2 - 1.8]) cylinder(r=2.8, h=1.8);
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
