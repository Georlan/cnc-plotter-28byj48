/*
  =============================================================================
  99_Teste_Tolerancias.scad - Cupom de Teste de Folgas FDM
  =============================================================================
  Gera 5 pares macho+fêmea com folgas progressivas:
    0.15, 0.20, 0.25, 0.30, 0.35 mm por lado
  
  Usa dovetail_male_x / dovetail_female_x corrigidos.
  
  RESULTADO: exatamente 10 COMPONENTES CONECTADOS no STL
  (5 machos + 5 fêmeas, todos com min Z = 0)
  =============================================================================
*/

include <00_Parametros.scad>;

clearances = [0.15, 0.20, 0.25, 0.30, 0.35];
test_length = 20.0;
spacing_x   = 25.0;

for (i = [0 : len(clearances) - 1]) {
  c = clearances[i];
  tx = i * spacing_x;

  // ====== MACHO ======
  translate([tx, 0, 0])
    dovetail_male_x(length=test_length);

  // ====== FÊMEA (bloco com canal cortado) ======
  translate([tx, 20, 0]) {
    difference() {
      // Bloco envoltório
      translate([-EPS, -(dovetail_width_top/2 + 3), 0])
        cube([test_length + EPS*2, dovetail_width_top + 6, dovetail_height + 3]);

      // Corte do canal com a folga de teste
      translate([0, 0, 0])
        dovetail_female_x(length=test_length, clearance=c);
    }
  }
}
