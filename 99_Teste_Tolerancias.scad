/*
  =============================================================================
  99_Teste_Tolerancias.scad - Cupom de Teste de Folgas FDM
  =============================================================================
  Gera 5 pares macho+fêmea com folgas progressivas, da esquerda para direita:
    0.18, 0.20, 0.22, 0.25, 0.28 mm por lado
  
  Usa dovetail_male_x / dovetail_female_x corrigidos.
  
  RESULTADO: exatamente 10 COMPONENTES CONECTADOS no STL
  (5 machos + 5 fêmeas, todos com min Z = 0)
  =============================================================================
*/

include <00_Parametros.scad>;

clearances = [0.18, 0.20, 0.22, 0.25, 0.28];
test_length = 20.0;
spacing_x   = 25.0;
female_h    = dovetail_height + 3.0;

for (i = [0 : len(clearances) - 1]) {
  c = clearances[i];
  tx = i * spacing_x;

  // ====== MACHO (Apoiado diretamente na mesa Z=0, sem suportes) ======
  translate([tx, 0, 0])
    dovetail_male_x(length=test_length);

  // ====== FÊMEA (Base sólida plana apoiada na mesa Z=0, canal aberto para CIMA - ZERO SUPORTES) ======
  translate([tx, 22, female_h]) {
    rotate([180, 0, 0]) {
      difference() {
        // Bloco envoltório
        translate([-EPS, -(dovetail_width_top/2 + 3), 0])
          cube([test_length + EPS*2, dovetail_width_top + 6, female_h]);

        // Corte do canal com a folga de teste
        translate([0, 0, 0])
          dovetail_female_x(length=test_length, clearance=c);
      }
    }
  }
}




