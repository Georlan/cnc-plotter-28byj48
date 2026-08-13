/*
  =============================================================================
  02_Carrinho_X.scad - Carrinho do Eixo X (GEOMETRIA CORRIGIDA DEFINITIVA)
  =============================================================================
  Correções aplicadas:
    - Motor X movido para a face frontal, fora do envelope do trilho Y
    - Flange do motor: orelhas independentes para motor_mount_spacing=35mm
    - Geometria redundante removida (cubo interno desnecessário)
    - Canal dovetail_female_x com orientação correta
    - Encaixe para trilho Y (socket retangular)
    - 1 ÚNICO COMPONENTE CONECTADO no STL
  
  Orientação de impressão: Z=0 no leito (fundo do carrinho).
  =============================================================================
*/

include <00_Parametros.scad>;

module carrinho_x() {
  // Dimensões do corpo principal
  cx_length = 28.0;  // X (comprimento ao longo do trilho)
  cx_width  = 28.0;  // Y (largura transversal)
  cx_height = 12.0;  // Z (altura total)

  // Posição Y do canal dovetail (centro do carrinho)
  dt_local_y = cx_width / 2;  // Y=14

  // Motor X: corpo fora da face frontal (-Y), eixo apontando para +Y.
  // Isso elimina a colisao do corpo de 28.2mm com o inicio do trilho Y.
  motor_z_local = (base_h + tooth_height / 2 + gear_pitch_radius) - base_h;
  // = tooth_height/2 + gear_pitch_radius ≈ 1.1 + 6.366 = 7.466mm
  motor_y_local = x_motor_face_y_local;

  // Centro da cremalheira X expresso no sistema local do carrinho.
  // A espessura do pinhao fica centrada nesta coordenada.
  rack_axis_y_local = x_rack_center_y - (base_w/2 - cx_width/2);

  // Posição X dos furos de montagem do motor (35mm c/c)
  motor_cx = cx_length / 2; // Centro do carrinho em X
  hole_left_x  = motor_cx - motor_flange_dist/2;  // -3.5
  hole_right_x = motor_cx + motor_flange_dist/2;  // 31.5

  // Socket para o trilho Y (abertura superior)
  socket_w = y_mount_tongue_w + 0.4;
  socket_d = y_mount_tongue_d + 0.4;
  socket_h = y_mount_tongue_h + 0.2;

  difference() {
    union() {
      color([0.35, 0.42, 0.48]) {
        // ====== CORPO PRINCIPAL ======
        cube([cx_length, cx_width, cx_height]);

        // ====== ORELHAS DO MOTOR (independentes, conectadas por braços) ======

        // Orelha esquerda (X = hole_left_x = -3.5)
        hull() {
          // Boss da orelha
          translate([hole_left_x, motor_y_local, motor_z_local])
            rotate([-90, 0, 0])
              cylinder(r=wall_screw, h=3.0);
          // Conexão ao corpo principal
          translate([0, motor_y_local, motor_z_local])
            rotate([-90, 0, 0])
              cylinder(r=wall_screw, h=3.0);
        }

        // Orelha direita (X = hole_right_x = 31.5)
        hull() {
          translate([hole_right_x, motor_y_local, motor_z_local])
            rotate([-90, 0, 0])
              cylinder(r=wall_screw, h=3.0);
          translate([cx_length, motor_y_local, motor_z_local])
            rotate([-90, 0, 0])
              cylinder(r=wall_screw, h=3.0);
        }
      }
    }

    // ====== CANAL DOVETAIL FÊMEA (corte no fundo) ======
    translate([0, dt_local_y, 0])
      dovetail_female_x(length=cx_length);

    // ====== FUROS M3 DE MONTAGEM DO MOTOR ======
    // Furo esquerdo
    translate([hole_left_x, motor_y_local - EPS, motor_z_local])
      rotate([-90, 0, 0])
        cylinder(r=motor_flange_hole_r, h=20);

    // Furo direito
    translate([hole_right_x, motor_y_local - EPS, motor_z_local])
      rotate([-90, 0, 0])
        cylinder(r=motor_flange_hole_r, h=20);

    // ====== BOLSO DO PINHAO X ======
    translate([motor_cx, rack_axis_y_local - pinion_thickness/2 - 0.2, motor_z_local])
      rotate([-90, 0, 0])
        cylinder(r=gear_outer_radius + 0.35, h=pinion_thickness + 0.4);

    // ====== SOCKET PARA O TRILHO Y ======
    // Encaixe retangular no topo do carrinho (face Z+)
    translate([cx_length/2 - socket_w/2, cx_width/2 - socket_d/2, cx_height - socket_h])
      cube([socket_w, socket_d, socket_h + EPS]);
  }
}

// Renderização para impressão/exportação
carrinho_x();
