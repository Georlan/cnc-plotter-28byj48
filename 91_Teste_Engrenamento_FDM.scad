/*
  Cupom fisico barato para validar a cremalheira/pinhao antes das pecas longas.
  Imprime dois componentes: rack curto e um pinhao real com furo D.
*/

include <00_Parametros.scad>;

coupon_length=36.0;
coupon_w=8.0;
coupon_base_h=2.0;

module rack_coupon() {
  union() {
    cube([coupon_length,coupon_w,coupon_base_h]);
    translate([2,coupon_w/2,coupon_base_h])
      rack_x(coupon_length-4);
  }
}

rack_coupon();
translate([50,coupon_w/2,0]) pinion_gear();
