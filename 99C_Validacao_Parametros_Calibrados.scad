/*
  Guarda de regressao dos parametros calibrados em 2026-08-17.
  Resultado correto: um cubo de 1 mm.
*/

include <00_Parametros.scad>;

TOL = 1e-6;

assert(abs(slide_clearance_xy - 0.22) < TOL,
       "slide_clearance_xy deve permanecer em 0.22 mm (Teste 99, par #3)");
assert(abs(slide_clearance_z - 0.15) < TOL,
       "slide_clearance_z deve permanecer em 0.15 mm");
assert(abs(passive_float - 0.60) < TOL,
       "passive_float deve permanecer em 0.60 mm");
assert(abs(pressfit_clearance - 0.15) < TOL,
       "pressfit_clearance deve permanecer em 0.15 mm");
assert(abs(shaft_clearance - 0.18) < TOL,
       "shaft_clearance deve permanecer em 0.18 mm (Teste Eixo Double-D #1)");

assert(abs(motor_body_diameter - 28.0) < TOL,
       "28BYJ-48: corpo deve ser Ø28.0 mm");
assert(abs(motor_mount_spacing - 35.0) < TOL,
       "28BYJ-48: espaçamento de montagem deve ser 35.0 mm");
assert(abs(motor_shaft_diameter - 5.0) < TOL,
       "28BYJ-48: eixo deve ser Ø5.0 mm");
assert(abs(motor_shaft_flat - 3.0) < TOL,
       "28BYJ-48: espessura entre faces Double-D deve ser 3.0 mm");
assert(abs(motor_shaft_flat_len - 6.0) < TOL,
       "28BYJ-48: comprimento das faces Double-D deve ser 6.0 mm");
assert(abs(motor_shaft_length - 8.5) < TOL,
       "28BYJ-48: comprimento livre do eixo deve ser 8.5 mm");
assert(abs(motor_flange_hole_r - 2.1) < TOL,
       "28BYJ-48: furos de flange devem ter raio 2.1 mm");
assert(abs(motor_boss_r - 4.5) < TOL,
       "28BYJ-48: boss deve ter raio 4.5 mm");

assert(motor_shaft_flat < motor_shaft_diameter,
       "Geometria Double-D inválida: largura entre faces deve ser menor que o diâmetro");

cube([1,1,1]);
