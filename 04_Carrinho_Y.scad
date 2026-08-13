/*
  Carrinho Y para a viga-caixao.

  O motor Y fica baixo e fora da lateral +X. O motor Z fica na face dianteira;
  os dois envelopes nao se cruzam. Uma torre de guia eleva o comprimento de
  apoio do embolo Z de 14 para 24 mm, reduzindo a folga angular da caneta.
*/

include <00_Parametros.scad>;

module carrinho_y() {
  dt_local_x = y_carriage_w/2;
  rack_local_x = dt_local_x + (y_rack_center_x-y_dovetail_center_x);
  motor_y_axis_z = rack_pitch_height + gear_pitch_radius + gear_mesh_clearance;
  motor_y_face_x = y_carriage_w;
  motor_y_center_y = y_carriage_length/2;
  z_slot_w = z_carriage_w + 2*slide_clearance_z;
  z_slot_d = z_carriage_d + 2*slide_clearance_z;
  tower_wall = 2.4;
  bottom_relief = 0.25;

  difference() {
    union() {
      cube([y_carriage_w,y_carriage_length,y_carriage_h]);

      // Torre anti-inclinacao do embolo Z.
      translate([z_axis_center_x_local-z_slot_w/2-tower_wall,
                 z_axis_center_y_local-z_slot_d/2-tower_wall,0])
        cube([z_slot_w+2*tower_wall,z_slot_d+2*tower_wall,
              z_guide_total_h]);

      // Flanges do motor Y, eixo apontando para -X.
      for (hy=[motor_y_center_y-motor_flange_dist/2,
               motor_y_center_y+motor_flange_dist/2])
        translate([motor_y_face_x,hy,motor_y_axis_z])
          rotate([0,-90,0]) cylinder(r=wall_screw,h=3.2);

      // Flanges do motor Z; a orelha direita se liga ao corpo por um pescoco.
      for (hx=[z_motor_axis_x_local-motor_flange_dist/2,
               z_motor_axis_x_local+motor_flange_dist/2])
        hull() {
          translate([hx,0,z_motor_axis_z_local])
            rotate([-90,0,0]) cylinder(r=wall_screw,h=3.2);
          translate([min(max(hx,wall_screw),y_carriage_w-wall_screw),
                     0,y_carriage_h-1])
            rotate([-90,0,0]) cylinder(r=wall_screw,h=3.2);
        }
    }

    // Canais rasos: no maximo 10 mm de ponte, sem suporte no fatiador.
    for (g=[[0,9],[12,8],[23,8],[34,10]])
      translate([g[0],-EPS,-EPS])
        cube([g[1],y_carriage_length+2*EPS,bottom_relief+EPS]);

    translate([dt_local_x,0,-0.5])
      dovetail_female_y(y_carriage_length);

    // Canal para a cremalheira Y e bolso do pinhao.
    translate([rack_local_x-(rack_width+0.8)/2,-EPS,-EPS])
      cube([rack_width+0.8,y_carriage_length+2*EPS,tooth_height+0.7]);
    translate([rack_local_x-pinion_thickness/2-0.2,
               motor_y_center_y,motor_y_axis_z])
      rotate([0,90,0])
        cylinder(r=gear_outer_radius+0.35,h=pinion_thickness+0.4);

    // Guia Z passante e corredor externo da cremalheira vertical.
    translate([z_axis_center_x_local-z_slot_w/2,
               z_axis_center_y_local-z_slot_d/2,-EPS])
      cube([z_slot_w,z_slot_d,z_guide_total_h+2*EPS]);
    translate([z_axis_center_x_local+z_rack_base_x-0.8,
               z_axis_center_y_local-(rack_width+0.8)/2,-EPS])
      cube([tooth_height+1.6,rack_width+0.8,z_guide_total_h+2*EPS]);

    // Bolso do pinhao Z.
    translate([z_motor_axis_x_local,
               z_axis_center_y_local-pinion_thickness/2-0.2,
               z_motor_axis_z_local])
      rotate([-90,0,0])
        cylinder(r=gear_outer_radius+0.35,h=pinion_thickness+0.4);

    for (hy=[motor_y_center_y-motor_flange_dist/2,
             motor_y_center_y+motor_flange_dist/2])
      translate([motor_y_face_x+EPS,hy,motor_y_axis_z])
        rotate([0,-90,0]) cylinder(r=motor_flange_hole_r,h=8);

    for (hx=[z_motor_axis_x_local-motor_flange_dist/2,
             z_motor_axis_x_local+motor_flange_dist/2])
      translate([hx,-EPS,z_motor_axis_z_local])
        rotate([-90,0,0]) cylinder(r=motor_flange_hole_r,h=8);
  }
}

carrinho_y();
