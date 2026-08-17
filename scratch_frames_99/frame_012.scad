
    include <00_Parametros.scad>;
    c = 0.22;
    test_len = 25.0;

    // Macho móvel
    color([0.15, 0.55, 0.90])
    translate([10.00, 0, 0])
      dovetail_male_x(length=test_len);

    // Bloco fêmea fixo com recorte
    color([0.80, 0.80, 0.85, 0.85])
    translate([0, 0, 0])
    difference() {
      translate([-EPS, -(dovetail_width_top/2 + 3.5), 0])
        cube([20 + EPS*2, dovetail_width_top + 7, dovetail_height + 3.5]);
      dovetail_female_x(length=20, clearance=c);
    }
    