/*
  Cupom fisico da interface FINAL do motor 28BYJ-48.

  A versao inicial deste cupom usava dois rasgos longos para descobrir se o
  motor real coincidia com a geometria nominal. Esse teste fisico foi aprovado.
  A interface final agora replica exatamente as pecas de producao:

    - ressalto frontal de 9 mm como datum coaxial;
    - dois furos redondos M3;
    - mesmo espacamento de 35 mm validado;
    - mesma altura/centro de eixo ja validado.

  Reimprimir este cupom e opcional; ele existe para inspecao e validacao da
  geometria final antes de uma futura troca de lote/fabricante de motor.
*/

include <00_MotorMount_Final.scad>;

coupon_w = motor_mount_spacing + 2*(motor_mount_pad_r + 2.0);
coupon_d = 34.0;
coupon_h = 4.0;
axis_x = coupon_w/2;
axis_y = 20.0;

assert(axis_y-motor_mount_line_offset-motor_mount_pad_r > 0,
       "Cupom curto no lado das orelhas");
assert(axis_y+motor_body_r <= coupon_d+0.1,
       "Cupom curto no lado do corpo do motor");
assert(abs(motor_mount_spacing-35.0) < 0.01,
       "Fixacao final deve manter o espacamento validado de 35 mm");

difference() {
  cube([coupon_w,coupon_d,coupon_h]);

  // O ressalto central localiza o eixo. Folga pequena, sem usar as orelhas
  // para centralizar o motor.
  translate([axis_x,axis_y,0])
    motor_28byj48_boss_passage_local(depth=coupon_h);

  // Passagem do eixo alem do ressalto.
  translate([axis_x,axis_y,0])
    motor_28byj48_shaft_passage_local(depth=coupon_h);

  // Fixacao final: dois furos redondos M3.
  translate([axis_x,axis_y,0])
    motor_28byj48_mount_final_fasteners_local(depth=coupon_h);
}
