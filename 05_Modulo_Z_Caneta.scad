/*
  =============================================================================
  05_Modulo_Z_Caneta.scad - Êmbolo Móvel Z da Caneta (GEOMETRIA CORRIGIDA)
  =============================================================================
  Correções:
    - Cremalheira Z usa rack_z() canônico com base sólida de 0.6mm
    - Rasgo de clamp flexível cortado apenas na parede frontal (Y <= 0)
      mantendo a parede traseira intacta (1 ÚNICO COMPONENTE CONECTADO)
    - Cavidade da mola de compliance preservada
  
  Orientação de impressão: base do êmbolo no leito (Z=0).
  =============================================================================
*/

include <00_Parametros.scad>;

module modulo_z_pen_plunger() {
  // Corpo do êmbolo
  plunger_w = 12.0;  // X
  plunger_d = 12.0;  // Y
  plunger_h = active_z_travel + compliance_travel + spring_length + 5.0;  // ≈28mm

  // Cavidade para a mola de compliance
  spring_r = spring_outer_diameter / 2 + 0.3;
  spring_z_start = 3.0;

  // Clamp da caneta
  pen_r = pen_diameter / 2 + pen_clearance;

  // Cremalheira Z integrada: dentes projetam em +X, espaçados ao longo de Z
  rack_z_height = active_z_travel + 6.0;  // comprimento útil do rack
  rack_z_width  = 4.0;

  difference() {
    union() {
      color([0.40, 0.48, 0.55]) {
        // Corpo cilíndrico principal
        cylinder(r=plunger_w/2, h=plunger_h);

        // Reforço quadrado na base para estabilidade
        translate([-plunger_w/2, -plunger_d/2, 0])
          cube([plunger_w, plunger_d, 6.0]);
      }

      // ====== CREMALHEIRA Z INTEGRADA ======
      // Base de 0.6mm afundada em 0.5mm dentro da parede lateral (+X)
      color([0.95, 0.85, 0.15])
        translate([plunger_w/2 - 0.5, 0, 2.0])
          rack_z(length=rack_z_height, width=rack_z_width);
    }

    // ====== FURO DA CANETA (passante, vertical) ======
    translate([0, 0, -EPS])
      cylinder(r=pen_r, h=plunger_h + EPS*2);

    // ====== CAVIDADE DA MOLA DE COMPLIANCE ======
    translate([0, 0, spring_z_start])
      cylinder(r=spring_r, h=spring_length + 2.0);

    // ====== RASGO DE CLAMP FLEXÍVEL (corta apenas a parede frontal Y <= 0) ======
    translate([-0.5, -plunger_d/2 - EPS, -EPS])
      cube([1.0, plunger_d/2 + EPS, plunger_h + EPS*2]);
  }
}

// Renderização para impressão/exportação
modulo_z_pen_plunger();
