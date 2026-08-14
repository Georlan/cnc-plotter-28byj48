/*
  Carrinhos do portico X.

  Pecas deste arquivo:
    1. carrinho_x_motriz()       — PLA, motor e pinhao X
    2. sapata_x_passiva()        — PETG, desliza no trilho traseiro
    3. sela_x_passiva()          — PLA, recebe a viga e flutua +/-0,60 mm em Y

  A sapata passiva e retida por um unico M3x8. O ressalto central fica 0,20 mm
  acima da sela: o parafuso aperta no ressalto, nao bloqueia o movimento lateral.
*/

include <00_Parametros.scad>;

module front_beam_key() {
  difference() {
    translate([x_carriage_length/2-beam_key_w/2,
               base_w/2+beam_key_inset, x_carriage_h-EPS])
      cube([beam_key_w,beam_key_d,beam_key_h+EPS]);
    translate([x_carriage_length/2,base_w/2+beam_key_inset-EPS,
               x_carriage_h+beam_key_h/2])
      rotate([-90,0,0]) cylinder(r=1.35,h=beam_key_d+2*EPS);
  }
}

module rear_beam_key(z0=passive_saddle_h) {
  difference() {
    translate([x_carriage_length/2-beam_key_w/2,
               base_w/2-beam_key_inset-beam_key_d,z0-EPS])
      cube([beam_key_w,beam_key_d,beam_key_h+EPS]);
    translate([x_carriage_length/2,
               base_w/2-beam_key_inset-beam_key_d-EPS,
               z0+beam_key_h/2])
      rotate([-90,0,0]) cylinder(r=1.35,h=beam_key_d+2*EPS);
    // Alivio do ombro flutuante no limite de +/-0,60 mm.
    hull()
      for (dy=[-passive_float,passive_float])
        translate([x_carriage_length/2,base_w/2+dy,z0-EPS])
          cylinder(r=2.45,h=beam_key_h+2*EPS);
  }
}

module carrinho_x_motriz() {
  motor_x_axis_z = rack_pitch_height + gear_pitch_radius + gear_mesh_clearance;
  motor_face_y = -motor_x_mount_standoff;
  pinion_pocket_y0 = x_rack_center_y-pinion_thickness/2
                     -pinion_pocket_axial_clearance;
  motor_passage_h = pinion_pocket_y0-motor_face_y+0.6;

  difference() {
    union() {
      cube([x_carriage_length,base_w,x_carriage_h]);

      // Ponte de montagem continua. Substitui duas orelhas visualmente
      // desconectadas e distribui o aperto dos parafusos no corpo do carrinho.
      hull()
        for (hx=[x_carriage_length/2-motor_flange_dist/2,
                 x_carriage_length/2+motor_flange_dist/2])
          translate([hx,motor_face_y,motor_x_axis_z])
            rotate([-90,0,0])
              cylinder(r=wall_screw,h=motor_x_mount_standoff+0.1);

      front_beam_key();
    }

    translate([0,base_w/2,-0.5])
      dovetail_female_x(x_carriage_length);

    // Passagem da cremalheira e bolso do pinhao.
    translate([-EPS,x_rack_center_y-(rack_width+0.8)/2,-EPS])
      cube([x_carriage_length+2*EPS,rack_width+0.8,tooth_height+0.7]);
    translate([x_carriage_length/2,
               pinion_pocket_y0,motor_x_axis_z])
      rotate([-90,0,0])
        cylinder(r=gear_outer_radius+pinion_pocket_radial_clearance,
                 h=pinion_thickness+2*pinion_pocket_axial_clearance);

    // Corredor coaxial do ressalto e do eixo do 28BYJ-48 ate o bolso do
    // pinhao. O corpo do motor permanece totalmente fora da peca impressa.
    translate([x_carriage_length/2,motor_face_y-EPS,motor_x_axis_z])
      rotate([-90,0,0])
        cylinder(r=motor_boss_r+motor_mount_clearance,
                 h=motor_passage_h+EPS);

    // A ponta do eixo D ultrapassa o bolso do pinhao em 0,70 mm. Um furo
    // estreito continua ate o comprimento total da saida sem debilitar a
    // ponte com o diametro maior do ressalto.
    translate([x_carriage_length/2,motor_face_y-EPS,motor_x_axis_z])
      rotate([-90,0,0])
        cylinder(r=motor_shaft_r+motor_mount_clearance,
                 h=motor_boss_h+motor_shaft_length+
                   motor_mount_clearance+EPS);

    for (hx=[x_carriage_length/2-motor_flange_dist/2,
             x_carriage_length/2+motor_flange_dist/2])
      translate([hx,motor_face_y-EPS,motor_x_axis_z])
        rotate([-90,0,0]) cylinder(r=motor_flange_hole_r,h=8);
  }
}

module sapata_x_passiva() {
  shoulder_h = passive_saddle_h + 0.20;
  difference() {
    union() {
      cube([x_carriage_length,base_w,passive_shoe_h]);
      translate([x_carriage_length/2-passive_boss_w/2,
                 base_w/2-passive_boss_d/2,passive_shoe_h-EPS])
        cube([passive_boss_w,passive_boss_d,passive_boss_h+EPS]);
      // Ombro de aperto: recebe a cabeca do M3 sem prensar a sela.
      translate([x_carriage_length/2,base_w/2,passive_shoe_h])
        cylinder(r=2.15,h=shoulder_h);
    }
    translate([0,base_w/2,-0.5])
      dovetail_female_x(x_carriage_length);
    translate([x_carriage_length/2,base_w/2,passive_shoe_h-EPS])
      cylinder(r=1.30,h=shoulder_h+2*EPS);
  }
}

module sela_x_passiva() {
  pocket_w = passive_boss_w + 2*pressfit_clearance;
  pocket_d = passive_boss_d + 2*passive_float + 2*pressfit_clearance;
  slot_r = 2.35;
  slide_relief = 0.25;

  difference() {
    union() {
      cube([x_carriage_length,base_w,passive_saddle_h]);
      rear_beam_key();
    }

    // Canais rasos: ponte maxima de 10 mm e apenas 21% de contato.
    for (g=[[0,9],[12,10],[25,10],[38,10],[51,5]])
      translate([g[0],-EPS,-EPS])
        cube([g[1],base_w+2*EPS,slide_relief+EPS]);

    // Bolso restringe X e libera somente o desalinhamento transversal Y.
    translate([x_carriage_length/2-pocket_w/2,
               base_w/2-pocket_d/2,-EPS])
      cube([pocket_w,pocket_d,passive_boss_h+pressfit_clearance+EPS]);

    // Rasgo do ombro/parafuso: 1,20 mm de movimento total em Y.
    hull() {
      for (dy=[-passive_float,passive_float])
        translate([x_carriage_length/2,base_w/2+dy,-EPS])
          cylinder(r=slot_r,h=passive_saddle_h+2*EPS);
    }
  }
}

// Alias usado por arquivos antigos e por quem quer apenas o carrinho motriz.
module carrinho_x() carrinho_x_motriz();

// Layout PLA: carrinho motriz e sela rigida. A sapata PETG fica em 02B.
carrinho_x_motriz();
translate([70,0,0]) sela_x_passiva();
