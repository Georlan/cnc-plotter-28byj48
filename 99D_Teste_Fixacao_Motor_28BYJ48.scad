/*
  Cupom fisico da interface do motor 28BYJ-48.

  Objetivo:
    - validar o ressalto frontal de 9 mm como datum coaxial;
    - validar passagem do eixo;
    - validar os dois rasgos M3;
    - absorver variantes comerciais de aproximadamente 31 a 39 mm entre
      centros sem deslocar o eixo do motor.

  Monte um motor real no cupom ANTES de reimprimir os carrinhos completos.
  O motor deve assentar pela face/ressalto; os parafusos apenas prendem.
*/

include <00_Parametros.scad>;

coupon_w = motor_mount_spacing_max + 2*(motor_mount_pad_r + 2.0);
coupon_d = 34.0;
coupon_h = 4.0;
axis_x = coupon_w/2;
axis_y = 20.0;

assert(axis_y-motor_mount_line_offset-motor_mount_pad_r > 0,
       "Cupom curto no lado das orelhas");
assert(axis_y+motor_body_r <= coupon_d+0.1,
       "Cupom curto no lado do corpo do motor");
assert(motor_mount_spacing_min <= 32.0,
       "Rasgos nao cobrem variante de 32 mm");
assert(motor_mount_spacing_max >= 35.0,
       "Rasgos nao cobrem nominal de 35 mm");

difference() {
  cube([coupon_w,coupon_d,coupon_h]);

  // O ressalto central localiza o eixo. Folga pequena, sem usar as orelhas
  // para centralizar o motor.
  translate([axis_x,axis_y,0])
    motor_28byj48_boss_passage_local(depth=coupon_h);

  // Passagem do eixo alem do ressalto.
  translate([axis_x,axis_y,0])
    motor_28byj48_shaft_passage_local(depth=coupon_h);

  // Rasgos ao longo da linha entre orelhas.
  translate([axis_x,axis_y,0])
    motor_28byj48_mount_slots_local(depth=coupon_h);
}
