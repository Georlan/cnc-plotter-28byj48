/* Guardas de altura, curso e forca do modulo Z. Resultado: um cubo de 1 mm. */
include <00_Parametros.scad>;

tip_down=z_plunger_down_z+pen_tip_uncompressed_z+nominal_compression;
tip_up=z_plunger_down_z+Z_UP+pen_tip_uncompressed_z;
force_nominal=spring_rate_target*(spring_preload+nominal_compression);
force_max=spring_rate_target*(spring_preload+compliance_travel);
guide_overlap_up=z_guide_total_h-(z_plunger_down_z-y_beam_top_z+Z_UP);

assert(abs(tip_down-(paper_z+paper_thickness)) < 0.001,
       "Ponta baixa nao coincide com a superficie do papel");
assert(abs((tip_up-tip_down)-pen_lift_clearance) < 0.001,
       "Elevacao livre da caneta diferente de 6 mm");
assert(force_nominal >= 0.3 && force_nominal <= 0.7,
       "Forca nominal fora da faixa segura de desenho");
assert(force_max <= 0.9,
       "Forca maxima pode marcar/rasgar papel fino");
assert(guide_overlap_up >= 12,
       "Embolo Z perde comprimento de guia na posicao alta");

cube([1,1,1]);
