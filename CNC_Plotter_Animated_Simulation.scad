/*
  Simulação cinemática da versão com dois trilhos X.

  OpenSCAD: View > Animate
    FPS   : 30
    Steps : 160

  A rotação dos três pinhões é calculada dentro da montagem com a relação
  9 graus/mm. A animação também injeta até +/-0,5 mm de erro no trilho passivo
  para tornar visível o funcionamento da sapata flutuante.
*/

include <00_Parametros.scad>;
use <CNC_Plotter_Full_Assembly.scad>;

ease = (1-cos($t*360))/2;
sim_x = X_MIN+(X_MAX-X_MIN)*ease;
sim_y = (Y_MIN+Y_MAX)/2
        + sin($t*720)*(Y_MAX-Y_MIN)*0.46;
sim_z = sin($t*1440) > 0 ? Z_UP : Z_DOWN;
sim_rail_error = 0.50*sin($t*360);

cnc_plotter_assembly(
  pos_x=sim_x,
  pos_y=sim_y,
  pos_z=sim_z,
  show_motors=true,
  show_fasteners=true,
  show_paper=true,
  show_debug=true,
  passive_rail_error=sim_rail_error
);
