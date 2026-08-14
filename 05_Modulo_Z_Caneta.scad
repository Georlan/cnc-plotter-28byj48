/*
  Modulo Z complacente com porta-ferramenta universal.

  O motor move o embolo 8 mm. Na posicao baixa, 2 mm desse curso comprimem a
  mola e os 6 mm restantes ficam disponiveis como afastamento real da folha.
  A mola metalica define a forca; o PETG/PLA apenas guia lateralmente.

  Uma haste padrao de 10 mm atravessa o guia. A caneta ou o pincel ficam em
  um mandril externo, abaixo do embolo, com buchas redutoras substituiveis.
  Assim a troca de diametro nao altera o guia, a mola ou a transmissao Z.
*/

include <00_Parametros.scad>;

function spring_force(compression=0) =
  spring_rate_target*(spring_preload+compression);

module modulo_z_pen_plunger(include_rack=true) {
  stem_r = tool_carrier_stem_diameter/2 + pen_clearance;
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
      cylinder(r=stem_r,h=z_cap_bottom+z_cap_h+2*EPS);
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
      cylinder(r=tool_carrier_stem_diameter/2+0.05,
               h=z_collar_h+2*EPS);
    translate([-slit_w/2,0,-EPS])
      cube([slit_w,11,z_collar_h+2*EPS]);
    translate([-6,7,z_collar_h/2]) rotate([0,90,0])
      cylinder(r=1.6,h=12);
  }
}

module z_universal_tool_carrier(include_stem=true) {
  holder_r = tool_holder_outer_diameter/2;
  bore_r = tool_holder_bore_diameter/2;
  holder_top_z = -tool_holder_top_gap;
  holder_bottom_z = holder_top_z-tool_holder_height;
  roof_h = tool_holder_height-tool_holder_grip_h;
  ear_w = 4.2;
  ear_gap = 1.8;
  ear_y = holder_r-1.5;
  ear_d = 7.0;
  screw_y = holder_r+2.0;
  screw_z = holder_bottom_z+tool_holder_height/2;

  assert(roof_h >= bore_r,
         "Teto interno do mandril excede 45 graus e pode exigir suporte");
  assert(tool_holder_bore_diameter < tool_holder_outer_diameter-4,
         "Parede do mandril universal muito fina");

  difference() {
    union() {
      translate([0,0,holder_bottom_z])
        cylinder(r=holder_r,h=tool_holder_height);

      if (include_stem)
        translate([0,0,holder_top_z-EPS])
          cylinder(r=tool_carrier_stem_diameter/2,
                   h=tool_carrier_stem_length+EPS);

      // Orelhas longas distribuem o aperto do M3 sem marcar a ferramenta.
      translate([-ear_gap/2-ear_w,ear_y,holder_bottom_z+4])
        cube([ear_w,ear_d,tool_holder_height-8]);
      translate([ear_gap/2,ear_y,holder_bottom_z+4])
        cube([ear_w,ear_d,tool_holder_height-8]);
    }

    // Trecho cilindrico de apoio e teto conico autoportante. O cone evita
    // uma ponte horizontal de 15,5 mm no fundo cego do mandril.
    translate([0,0,holder_bottom_z-EPS])
      cylinder(r=bore_r,h=tool_holder_grip_h+EPS);
    translate([0,0,holder_bottom_z+tool_holder_grip_h-EPS])
      cylinder(r1=bore_r,r2=0,
               h=roof_h+2*EPS);

    // Fenda de flexao e parafuso transversal M3 com alojamento de porca.
    translate([-tool_holder_slit/2,0,holder_bottom_z-EPS])
      cube([tool_holder_slit,holder_r+ear_d+EPS,
            tool_holder_height+2*EPS]);
    translate([-7,screw_y,screw_z]) rotate([0,90,0])
      cylinder(r=1.65,h=14);
    translate([2.0,screw_y,screw_z]) rotate([0,90,0])
      cylinder(r=3.15,h=3.3,$fn=6);
  }
}

module z_tool_reducer_sleeve(tool_diameter=10.0) {
  sleeve_r = tool_sleeve_outer_diameter/2;
  tool_r = tool_diameter/2+tool_sleeve_clearance;

  assert(tool_r < sleeve_r-0.65,
         "Parede da bucha redutora muito fina");

  difference() {
    cylinder(r=sleeve_r,h=tool_sleeve_height);
    translate([0,0,-EPS])
      cylinder(r=tool_r,h=tool_sleeve_height+2*EPS);
    translate([-tool_holder_slit/2,0,-EPS])
      cube([tool_holder_slit,sleeve_r+EPS,
            tool_sleeve_height+2*EPS]);
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

module tool_reference(tip_z=pen_tip_uncompressed_z, diameter=10.0) {
  holder_bottom_z = -tool_holder_top_gap-tool_holder_height;
  tool_top_z = holder_bottom_z+tool_holder_grip_h-1.0;
  bristle_h = 10.0;
  ferrule_h = 8.0;

  color([0.48,0.24,0.08])
    translate([0,0,tip_z])
      cylinder(r1=0.45,r2=diameter*0.30,h=bristle_h);
  color([0.72,0.72,0.76])
    translate([0,0,tip_z+bristle_h])
      cylinder(r=diameter/2,h=ferrule_h);
  color([0.12,0.10,0.08])
    translate([0,0,tip_z+bristle_h+ferrule_h])
      cylinder(r=diameter/2,
               h=max(0.1,tool_top_z-tip_z-bristle_h-ferrule_h));
}

// Alias para arquivos auxiliares antigos.
module pen_reference(tip_z=pen_tip_uncompressed_z, length=140) {
  tool_reference(tip_z=tip_z,diameter=pen_diameter);
}

module modulo_z_pen_assembly(compression=0, show_pen=true) {
  modulo_z_pen_plunger();

  // Haste, mandril e ferramenta se movem juntos enquanto a mola comprime.
  translate([0,0,compression]) {
    z_universal_tool_carrier();
    if (show_pen)
      tool_reference(tip_z=pen_tip_uncompressed_z,
                     diameter=10.0);
  }
  translate([0,0,z_carriage_body_h+compression]) z_pen_collar();
  translate([0,0,z_carriage_body_h+z_collar_h+compression])
    z_compression_spring_reference(compression);
}

// Layout PETG: embolo, colar, porta-ferramenta e tres buchas redutoras.
// A mola, o parafuso e a ferramenta sao apenas referencias de montagem.
modulo_z_pen_plunger();
translate([32,0,0]) z_pen_collar();
translate([65,0,tool_holder_height+tool_holder_top_gap])
  z_universal_tool_carrier();
for (i=[0:len(tool_sleeve_sizes)-1])
  translate([96+i*20,0,0])
    z_tool_reducer_sleeve(tool_sleeve_sizes[i]);
