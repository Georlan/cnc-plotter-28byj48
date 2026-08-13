include <00_Parametros.scad>;
use <CNC_Plotter_Full_Assembly.scad>;

// Compile com -D 'VALIDATION_POSITION=0..4'. Este arquivo nao e uma peca de
// impressao; serve para renderizar configuracoes repetiveis da montagem.
VALIDATION_POSITION = 0;

positions = [
  [(X_MIN + X_MAX)/2, (Y_MIN + Y_MAX)/2, Z_UP],
  [X_MIN, Y_MIN, Z_DOWN],
  [X_MIN, Y_MAX, Z_UP],
  [X_MAX, Y_MIN, Z_UP],
  [X_MAX, Y_MAX, Z_DOWN]
];

p = positions[VALIDATION_POSITION];
cnc_plotter_assembly(pos_x=p[0], pos_y=p[1], pos_z=p[2],
                     show_motors=true, show_fasteners=true, show_paper=true);
