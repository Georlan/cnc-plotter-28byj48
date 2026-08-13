/*
  =============================================================================
  CNC_Plotter_Animated_Simulation.scad - Simulação de Animação em Tempo Real
  =============================================================================
  Como Executar a Animação no OpenSCAD:
  1. Abra este arquivo no OpenSCAD.
  2. Vá no menu superior: View ➔ Animate
  3. Insira nos campos no canto inferior direito:
     - FPS: 30
     - Steps: 100
  =============================================================================
  A simulação respeita rigorosamente os limites mecânicos físicos (X_MIN/X_MAX,
  Y_MIN/Y_MAX, Z_UP/Z_DOWN) e simula a rotação dos pinhões X e Y e o Pen-Up/Down!
*/

include <00_Parametros.scad>;

use <CNC_Plotter_Full_Assembly.scad>;

// -----------------------------------------------------------------------------
// VARIÁVEIS DE MOVIMENTO KINEMÁTICO SINCRONIZADO ($t varia de 0.0 a 1.0)
// -----------------------------------------------------------------------------
// Movimento suave do Eixo X dentro do curso útil (X_MIN..X_MAX)
sim_x = X_MIN + ((X_MAX - X_MIN) / 2) + (sin($t * 360) * ((X_MAX - X_MIN) / 2.2));

// Movimento dinâmico do Eixo Y dentro do curso útil (Y_MIN..Y_MAX)
sim_y = Y_MIN + ((Y_MAX - Y_MIN) / 2) + (cos($t * 360 * 2) * ((Y_MAX - Y_MIN) / 2.2));

// Movimento Z da caneta: Eleva em Pen-Up (6.0mm) e desce em Pen-Down (0.0mm) no papel
sim_z = (sin($t * 360 * 4) > 0) ? Z_UP : Z_DOWN;

// -----------------------------------------------------------------------------
// RENDERIZAÇÃO DA MONTAGEM ANIMADA EM TEMPO REAL
// -----------------------------------------------------------------------------
cnc_plotter_assembly(
  pos_x = sim_x,
  pos_y = sim_y,
  pos_z = sim_z,
  show_motors = true,
  show_paper  = true,
  show_legacy = false,
  show_debug  = false,
  exploded    = 0.0
);
