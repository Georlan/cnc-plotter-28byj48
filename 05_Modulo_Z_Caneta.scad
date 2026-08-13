/*
  Modulo Z complacente.

  O motor move o embolo 8 mm. Na posicao baixa, 2 mm desse curso comprimem a
  mola e os 6 mm restantes ficam disponiveis como afastamento real da folha.
  A mola metalica define a forca; o PETG/PLA apenas guia lateralmente.
*/

include <00_Parametros.scad>;

function spring_force(compression=0) =
  spring_rate_target*(spring_preload+compression);

module modulo_z_pen_plunger(include_rack=true) {
  pen_r = pen_diameter/2 + pen_clearance;
  difference() {
    union() {
      translate([-z_carriage_w/2,-z_carriage_d/2,0])
        cube([z_carriage_w,z_carriage_d,z_carriage_body_h]);

      for (sx=[-1,1])
        translate([sx < 0 ? -z_cage_w/2 : z_cage_w/2-z_post_w,
                   -z_cage_d/2,z_carriage_body_h-EPS])
          cube([z_post_w,z_cage_d,
                z_cap_bottom-z_carriage_body_h+EPS]);

      translate([-z_cage_w/2,-z_cage_d/2,z_cap_bottom])
        cube([z_cage_w,z_cage_d,z_cap_h]);

      if (include_rack)
        translate([z_rack_base_x,0,z_rack_start])
          rack_z(z_rack_length);
    }

    translate([0,0,-EPS])
      cylinder(r=pen_r,h=z_cap_bottom+z_cap_h+2*EPS);
  }
}

module z_pen_collar() {
  slit_w = 1.0;
  difference() {
    union() {
      cylinder(r=z_collar_od/2,h=z_collar_h);
      translate([-4,4,0]) cube([3.5,6,z_collar_h]);
      translate([0.5,4,0]) cube([3.5,6,z_collar_h]);
    }
    translate([0,0,-EPS])
      cylinder(r=pen_diameter/2+0.05,h=z_collar_h+2*EPS);
    translate([-slit_w/2,0,-EPS])
      cube([slit_w,11,z_collar_h+2*EPS]);
    translate([-6,7,z_collar_h/2]) rotate([0,90,0])
      cylinder(r=1.6,h=12);
  }
}

module z_compression_spring_reference(compression=0) {
  spring_h = spring_length-spring_preload-compression;
  assert(compression >= 0 && compression <= compliance_travel,
         "Compressao da mola fora do curso complacente");
  color([0.75,0.75,0.78,0.7]) difference() {
    cylinder(r=spring_outer_diameter/2,h=spring_h);
    translate([0,0,-EPS])
      cylinder(r=spring_inner_diameter/2,h=spring_h+2*EPS);
  }
}

module pen_reference(tip_z=pen_tip_uncompressed_z, length=140) {
  color([0.10,0.10,0.12]) {
    translate([0,0,tip_z+3]) cylinder(r=pen_diameter/2,h=length-3);
    translate([0,0,tip_z]) cylinder(r1=0.45,r2=pen_diameter/2,h=3);
  }
}

module modulo_z_pen_assembly(compression=0, show_pen=true) {
  modulo_z_pen_plunger();
  translate([0,0,z_carriage_body_h+compression]) z_pen_collar();
  translate([0,0,z_carriage_body_h+z_collar_h+compression])
    z_compression_spring_reference(compression);
  if (show_pen) pen_reference(tip_z=pen_tip_uncompressed_z+compression);
}

// Layout de impressao: embolo e colar. A mola e a caneta sao referencias.
modulo_z_pen_plunger();
translate([32,0,0]) z_pen_collar();
