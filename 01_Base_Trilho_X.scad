/*
  Trilho X dianteiro/motriz.
  Perfil aberto nervurado: rigido onde importa, sem preencher o volume inteiro.
  Imprimir em PLA, fundo plano no leito, brim de 5 mm.
*/

include <00_Parametros.scad>;

module base_trilho_x(length=x_rail_length, include_rack=true) {
  dt_y = base_w/2;
  rib_w = wall_structural;
  skin_top = base_h-0.4;
  dt_platform_w = dovetail_width_bottom + 1.4;
  rack_platform_w = rack_width + 1.2;

  difference() {
    union() {
      // Piso, duas longarinas laterais e alma central.
      cube([length,base_w,floor_h]);
      cube([length,wall_thin,skin_top]);
      translate([0,base_w-wall_thin,0]) cube([length,wall_thin,skin_top]);
      translate([0,dt_y-rib_w/2,0]) cube([length,rib_w,skin_top]);

      // Mesas locais sob as superficies funcionais.
      translate([0,dt_y-dt_platform_w/2,skin_top-2.0])
        cube([length,dt_platform_w,2.0+EPS]);

      if (include_rack) {
        translate([0,x_rack_center_y-rib_w/2,0])
          cube([length,rib_w,skin_top]);
        translate([0,x_rack_center_y-rack_platform_w/2,skin_top-2.0])
          cube([length,rack_platform_w,2.0+EPS]);
      }

      // Diafragmas de torcao; espacamento de 40 mm.
      for (cx=[40:40:length-20])
        translate([cx-wall_thin/2,wall_thin,floor_h-EPS])
          cube([wall_thin,base_w-2*wall_thin,skin_top-floor_h+EPS]);

      translate([0,dt_y,base_h-0.5]) dovetail_male_x(length);
      if (include_rack)
        translate([0,x_rack_center_y,base_h]) rack_x(length);
    }

    // Quatro pontos evitam que o trilho longo arqueie sobre a base de MDF.
    for (fx=[20,73,147,length-20])
      translate([fx,base_w-5,-EPS]) cylinder(r=2.15,h=floor_h+2*EPS);
  }
}

module trilho_x_motriz() base_trilho_x(include_rack=true);
module trilho_x_passivo() base_trilho_x(include_rack=false);

trilho_x_motriz();
