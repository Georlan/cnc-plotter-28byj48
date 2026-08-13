/* Guardas parametricas da arquitetura. Resultado: um cubo de 1 mm. */
include <00_Parametros.scad>;

inner_gap=x_rail_spacing-base_w;
beam_slenderness=y_rail_length/y_beam_h;

assert(inner_gap >= paper_height+4,
       "Papel A5 invade os trilhos X");
assert(x_rail_length <= 250 && y_rail_length <= 250,
       "Peca longa deixa de caber na Bambu Lab A1 com brim");
assert(y_beam_wall >= 1.6,
       "Parede da viga abaixo de quatro linhas com bico 0,4");
assert(y_beam_rib_pitch <= 2*y_beam_h,
       "Diafragmas muito afastados para controlar torcao local");
assert(beam_slenderness <= 10.5,
       "Viga excessivamente esbelta");
assert(passive_float >= 0.5,
       "Sapata passiva sem curso para absorver erro de paralelismo");
assert(beam_key_w >= 2*wall_screw+8,
       "Chaveta da viga estreita demais ao redor do M3");

cube([1,1,1]);
