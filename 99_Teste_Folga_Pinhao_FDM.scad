/*
  Cupom pequeno para validar a folga real do pinhao antes dos carrinhos.

  Imprime tres componentes:
    1. um pinhao real;
    2. um anel que valida a folga radial do bolso;
    3. um garfo que valida a folga axial entre as paredes.

  O pinhao deve entrar e girar no anel sem raspar. Tambem deve passar entre
  as paredes do garfo sem precisar ser forcado.
*/

include <00_Parametros.scad>;

coupon_wall = 2.4;
radial_h = 4.0;
axial_gap = pinion_thickness + 2*pinion_pocket_axial_clearance;

module radial_clearance_coupon() {
  difference() {
    cylinder(r=gear_outer_radius+pinion_pocket_radial_clearance+coupon_wall,
             h=radial_h);
    translate([0,0,-EPS])
      cylinder(r=gear_outer_radius+pinion_pocket_radial_clearance,
               h=radial_h+2*EPS);
  }
}

module axial_clearance_coupon() {
  base_w = 18;
  base_d = 12;
  wall_h = 10;
  wall_t = 2.4;

  union() {
    cube([base_w,base_d,2]);
    cube([wall_t,base_d,wall_h]);
    translate([wall_t+axial_gap,0,0]) cube([wall_t,base_d,wall_h]);
  }
}

pinion_gear();
translate([24,0,0]) radial_clearance_coupon();
translate([42,-6,0]) axial_clearance_coupon();

echo("Folga radial do bolso por lado:",pinion_pocket_radial_clearance,"mm");
echo("Folga axial do bolso por lado:",pinion_pocket_axial_clearance,"mm");
