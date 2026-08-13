/*
  Viga/guia Y apoiada nas duas extremidades.

  Secao 30 x 24 mm, parede de 1,8 mm e diafragmas a cada 40 mm. A secao
  fechada resiste muito melhor a torcao que uma placa macica de massa parecida.
  Os encaixes inferiores posicionam a viga; um M3 em cada face de extremidade
  impede levantamento. Imprimir em PLA, como modelado, sem suporte.

  Nota STL: e uma unica peca material. Os seis vazios fechados geram sete
  cascas topologicas (uma externa + seis internas) em analisadores de malha.
*/

include <00_Parametros.scad>;

module y_box_shell(length=y_rail_length) {
  segment_count = floor(length/y_beam_rib_pitch);
  difference() {
    translate([-y_beam_w/2,0,0]) cube([y_beam_w,length,y_beam_h]);

    // Cavidades segmentadas deixam paredes externas e diafragmas integrais.
    for (k=[0:segment_count-1]) {
      cavity_y0 = k*y_beam_rib_pitch
                   + (k == 0 ? y_beam_wall : y_beam_rib_t/2);
      cavity_y1 = (k == segment_count-1)
                   ? length-y_beam_wall
                   : (k+1)*y_beam_rib_pitch-y_beam_rib_t/2;
      translate([-y_beam_w/2+y_beam_wall,cavity_y0,y_beam_wall])
        cube([y_beam_w-2*y_beam_wall,
              cavity_y1-cavity_y0,
              y_beam_h-2*y_beam_wall]);
    }
  }
}

module trilho_y(length=y_rail_length, include_rack=true) {
  front_socket_y = beam_key_inset;
  rear_socket_y = length-beam_key_inset-beam_key_d;
  socket_w = beam_key_w + 2*beam_socket_clearance;
  socket_d = beam_key_d + beam_socket_clearance;
  socket_h = beam_key_h + beam_socket_clearance;

  difference() {
    union() {
      y_box_shell(length);

      // Material apenas ao redor dos encaixes, sem preencher as pontas inteiras.
      translate([-12,0,0]) cube([24,beam_key_d+4,6]);
      translate([-12,length-beam_key_d-4,0]) cube([24,beam_key_d+4,6]);

      translate([y_dovetail_center_x,0,y_beam_h-0.5])
        dovetail_male_y(length);
      if (include_rack)
        translate([y_rack_center_x,0,y_beam_h]) rack_y(length);
    }

    // Bolsos cegos: a parede da extremidade permanece para apoiar a cabeca M3.
    translate([-socket_w/2,front_socket_y-EPS,-EPS])
      cube([socket_w,socket_d+EPS,socket_h+EPS]);
    translate([-socket_w/2,rear_socket_y-beam_socket_clearance,-EPS])
      cube([socket_w,socket_d+EPS,socket_h+EPS]);

    // Um parafuso axial por ponta. O parafuso rosca na chaveta do carrinho.
    translate([0,-EPS,beam_key_h/2])
      rotate([-90,0,0]) cylinder(r=beam_mount_hole_r,
                                 h=beam_key_inset+4.0);
    translate([0,length+EPS,beam_key_h/2])
      rotate([90,0,0]) cylinder(r=beam_mount_hole_r,
                                h=beam_key_inset+4.0);
  }
}

trilho_y();
