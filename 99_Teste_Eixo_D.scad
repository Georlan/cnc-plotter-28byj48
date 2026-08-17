/*
  =============================================================================
  99_Teste_Eixo_D.scad - Cupom de Calibração do Furo Double-D do 28BYJ-48
  =============================================================================
  Série realmente impressa na Bambu Lab A1 (PLA, bico 0.4 mm):
    - 0.18 mm (APROVADO: justo, sem patinar e sem exigir força)
    - 0.22 mm (comparação)
    - 0.25 mm (comparação)
    - 0.28 mm (comparação)

  RESULTADO FÍSICO: pinhão #1 = 0.18 mm.
  DECISÃO: shaft_clearance = 0.18 mm.
  =============================================================================
*/

include <00_Parametros.scad>;

clearances = [0.18, 0.22, 0.25, 0.28];
test_h = 6.0;
spacing = 24.0;

for (i = [0 : len(clearances)-1]) {
  c = clearances[i];
  tx = i * spacing;

  translate([tx, 0, 0]) {
    // 1. Pinhão limpo; pinion_gear() usa o Double-D global e recebe a folga do cupom.
    pinion_gear(thickness=test_h, clearance=c);

    // 2. Plaqueta frontal de identificação
    translate([-9, -17, 0]) {
      difference() {
        cube([18, 8.5, 1.2]);

        translate([9, 4.25, 0.5])
          linear_extrude(1.0)
            text(str(c), size=3.0, font="Liberation Sans:style=Bold", halign="center", valign="center");
      }
    }

    // Micro-ponte de união para a plaqueta não soltar na impressão.
    translate([-1.2, -8.6, 0])
      cube([2.4, 1.2, 0.8]);
  }
}
