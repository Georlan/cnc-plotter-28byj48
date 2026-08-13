/*
  =============================================================================
  90_Componentes_Referencia.scad - Modelos Visuais de Referência
  =============================================================================
  Modelos simplificados não-imprimíveis para visualização na montagem.
  Usa d_shaft_solid() unificado para o eixo D do motor.
  =============================================================================
*/

include <00_Parametros.scad>;

// Orientacoes canonicas de montagem. O eixo local do 28BYJ-48 e +Z.
// A rotacao adicional do motor Y gira apenas a chapa ao redor do proprio eixo,
// alinhando suas orelhas com os dois furos separados ao longo de Y.
module orient_motor_x() { rotate([-90,0,0]) children(); }
module orient_motor_y() { rotate([0,-90,0]) rotate([0,0,90]) children(); }
module orient_motor_z() { rotate([-90,0,0]) children(); }

// Envelopes separados permitem testar o que fica atras da face de montagem e
// o que precisa passar pelos furos coaxiais da peca impressa.
module motor_28byj48_body_envelope(clearance=0, face_relief=0.05) {
  translate([0, 0, -motor_body_h - clearance])
    cylinder(r=motor_body_r + clearance,
             h=motor_body_h + clearance - face_relief);
}

module motor_28byj48_flange_envelope(clearance=0, face_relief=0.05) {
  hull()
    for (dx=[-motor_flange_dist/2,motor_flange_dist/2])
      translate([dx,0,-motor_flange_thickness-clearance])
        cylinder(r=motor_flange_outer_r+clearance,
                 h=motor_flange_thickness+clearance-face_relief);
}

module motor_28byj48_back_envelope(clearance=0, face_relief=0.05) {
  union() {
    motor_28byj48_body_envelope(clearance,face_relief);
    motor_28byj48_flange_envelope(clearance,face_relief);
  }
}

module motor_28byj48_output_envelope(clearance=0, base_relief=0.03) {
  translate([0,0,base_relief])
    cylinder(r=motor_boss_r+clearance,
             h=motor_boss_h-base_relief);
  translate([0,0,motor_boss_h])
    cylinder(r=motor_shaft_r+clearance,h=motor_shaft_length);
}

module motor_28byj48_flange_reference() {
  difference() {
    hull()
      for (dx=[-motor_flange_dist/2,motor_flange_dist/2])
        translate([dx,0,-motor_flange_thickness])
          cylinder(r=motor_flange_outer_r,h=motor_flange_thickness);

    for (dx=[-motor_flange_dist/2,motor_flange_dist/2])
      translate([dx,0,-motor_flange_thickness-EPS])
        cylinder(r=motor_flange_hole_r,
                 h=motor_flange_thickness+2*EPS);
  }
}

module motor_28byj48_reference() {
  // A face de montagem/saida e Z=0. O corpo fica em Z negativo e o eixo
  // aponta para Z positivo, como no motor real. Isso torna a montagem inequivoca.
  color([0.7, 0.7, 0.72])
    translate([0, 0, -motor_body_h])
      cylinder(r=motor_body_r, h=motor_body_h);

  // Chapa frontal continua com as duas orelhas. No modelo anterior os furos
  // eram aneis soltos, fazendo o motor parecer suspenso no ar.
  color([0.60,0.60,0.63])
    motor_28byj48_flange_reference();

  // Boss de saída do eixo
  color([0.65, 0.65, 0.68])
    translate([0, 0, 0])
      cylinder(r=motor_boss_r, h=motor_boss_h);

  // Eixo D (usando módulo unificado)
  color([0.8, 0.8, 0.85])
    translate([0, 0, motor_boss_h])
      d_shaft_solid(h=motor_shaft_length);

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
