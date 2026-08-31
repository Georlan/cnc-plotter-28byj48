/*
  Carrinho Y para a viga-caixao.

  O motor Y fica baixo e fora da lateral +X. O motor Z fica na face dianteira;
  os dois envelopes nao se cruzam. Uma torre de guia eleva o comprimento de
  apoio do embolo Z de 14 para 24 mm, reduzindo a folga angular da caneta.
*/

include <00_MotorMount_Final.scad>;

module carrinho_y() {
  dt_local_x = y_carriage_w/2;
  rack_local_x = dt_local_x + (y_rack_center_x-y_dovetail_center_x);
  // Mantem exatamente a altura cinemática ja validada do eixo/pinhao Y.
  motor_y_axis_z = rack_pitch_height + gear_pitch_radius + gear_mesh_clearance;
  motor_y_face_x = y_carriage_w;
  motor_y_center_y = y_carriage_length/2;
  pinion_y_pocket_x0 = rack_local_x-pinion_thickness/2
                       -pinion_pocket_axial_clearance;
  pinion_y_pocket_x1 = pinion_y_pocket_x0+pinion_thickness
                       +2*pinion_pocket_axial_clearance;
  motor_y_passage_h = motor_y_face_x-pinion_y_pocket_x1+0.6;
  pinion_z_pocket_y0 = z_axis_center_y_local-pinion_thickness/2
                       -pinion_pocket_axial_clearance;
  motor_z_passage_h = pinion_z_pocket_y0+0.6;
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

      // Motor Y: eixo = datum; as orelhas permanecem 8 mm acima do eixo.
      // A fixacao final usa um furo redondo de referencia e um rasgo curto.
      translate([motor_y_face_x,motor_y_center_y,motor_y_axis_z])
        orient_motor_y()
          motor_28byj48_mount_final_bridge_local();

      // Motor Z: gira 180 graus em torno do proprio eixo, colocando as orelhas
      // 8 mm abaixo do eixo. A mesma fixacao rigida e usada sem alterar Z.
      translate([z_motor_axis_x_local,0,z_motor_axis_z_local])
        orient_motor_z()
          motor_28byj48_mount_final_bridge_local();
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
    translate([pinion_y_pocket_x0,
               motor_y_center_y,motor_y_axis_z])
      rotate([0,90,0])
        cylinder(r=gear_outer_radius+pinion_pocket_radial_clearance,
                 h=pinion_thickness+2*pinion_pocket_axial_clearance);

    // Ressalto/eixo do Y localizam o motor coaxialmente. A flange fica travada
    // pelo furo redondo + rasgo curto, sem usar os parafusos como datum.
    translate([motor_y_face_x,motor_y_center_y,motor_y_axis_z])
      orient_motor_y()
        motor_28byj48_boss_passage_local(depth=motor_y_passage_h+EPS);
    translate([motor_y_face_x,motor_y_center_y,motor_y_axis_z])
      orient_motor_y()
        motor_28byj48_shaft_passage_local(
          depth=motor_boss_h+motor_shaft_length+
                motor_mount_clearance+EPS);
    translate([motor_y_face_x,motor_y_center_y,motor_y_axis_z])
      orient_motor_y()
        motor_28byj48_mount_final_fasteners_local(depth=8);

    // Guia Z passante e corredor externo da cremalheira vertical.
    translate([z_axis_center_x_local-z_slot_w/2,
               z_axis_center_y_local-z_slot_d/2,-EPS])
      cube([z_slot_w,z_slot_d,z_guide_total_h+2*EPS]);
    translate([z_axis_center_x_local+z_rack_base_x-0.8,
               z_axis_center_y_local-(rack_width+0.8)/2,-EPS])
      cube([tooth_height+1.6,rack_width+0.8,z_guide_total_h+2*EPS]);

    // Bolso do pinhao Z.
    translate([z_motor_axis_x_local,
               pinion_z_pocket_y0,
               z_motor_axis_z_local])
      rotate([-90,0,0])
        cylinder(r=gear_outer_radius+pinion_pocket_radial_clearance,
                 h=pinion_thickness+2*pinion_pocket_axial_clearance);

    // Ressalto/eixo do Z mantem a cinemática; o motor segue apenas girado ao
    // redor do proprio eixo para levar as orelhas a uma regiao estrutural.
    translate([z_motor_axis_x_local,0,z_motor_axis_z_local])
      orient_motor_z()
        motor_28byj48_boss_passage_local(depth=motor_z_passage_h+EPS);
    translate([z_motor_axis_x_local,0,z_motor_axis_z_local])
      orient_motor_z()
        motor_28byj48_shaft_passage_local(
          depth=motor_boss_h+motor_shaft_length+
                motor_mount_clearance+EPS);
    translate([z_motor_axis_x_local,0,z_motor_axis_z_local])
      orient_motor_z()
        motor_28byj48_mount_final_fasteners_local(depth=8);
  }
}

carrinho_y();
