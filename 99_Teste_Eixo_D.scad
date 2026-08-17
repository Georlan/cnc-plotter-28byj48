/*
  =============================================================================
  99_Teste_Eixo_D.scad - Cupom de Calibração do Furo D do Motor 28BYJ-48
  =============================================================================
  Imprime 4 pinhões com folgas progressivas e etiquetas frontais limpas:
    - 0.18 mm (justo)
    - 0.22 mm (nominal atualizado)
    - 0.25 mm (confortável)
    - 0.28 mm (livre)
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
    // 1. Pinhão 100% limpo, sem texto cortando os dentes
    pinion_gear(thickness=test_h, clearance=c);

    // 2. Plaqueta frontal de identificação
    translate([-9, -17, 0]) {
      difference() {
        // Base da plaqueta
        cube([18, 8.5, 1.2]);

        // Texto em baixo-relevo com o valor exato da folga
        translate([9, 4.25, 0.5])
          linear_extrude(1.0)
            text(str(c), size=3.0, font="Liberation Sans:style=Bold", halign="center", valign="center");
      }
    }

    // Micro-ponte de união para a plaqueta não soltar na impressão (fácil de destacar)
    translate([-1.2, -8.6, 0])
      cube([2.4, 1.2, 0.8]);
  }
}
