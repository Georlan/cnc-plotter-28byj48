/*
  Cupom barato do porta-ferramenta universal.

  Imprima antes do modulo Z completo. O corpo testa o aperto do M3 e as tres
  buchas testam cabos redondos nominais de 7,5, 10,0 e 12,5 mm. Cabos entre
  aproximadamente 14 e 15 mm podem ser presos diretamente no corpo.
*/

include <00_Parametros.scad>;
use <05_Modulo_Z_Caneta.scad>;

// Corpo sem a longa haste Z: mesma cavidade, fenda, orelhas e porca do final.
translate([0,0,tool_holder_height+tool_holder_top_gap])
  z_universal_tool_carrier(include_stem=false);

for (i=[0:len(tool_sleeve_sizes)-1])
  translate([30+i*20,0,0])
    z_tool_reducer_sleeve(tool_sleeve_sizes[i]);
