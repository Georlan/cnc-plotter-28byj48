/*
  =============================================================================
  02_Carrinho_X.scad - Carrinho do Eixo X (GEOMETRIA CORRIGIDA DEFINITIVA)
  =============================================================================
  Correções aplicadas:
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

  // Motor X: eixo apontando para +Y (em direção à cremalheira)
  // O motor fica na face Y+ do carrinho
  motor_z_local = (base_h + tooth_height / 2 + gear_pitch_radius) - base_h;
  // = tooth_height/2 + gear_pitch_radius ≈ 1.1 + 6.366 = 7.466mm
  motor_y_local = cx_width - 3.0;  // Perto da face +Y

  // Posição X dos furos de montagem do motor (35mm c/c)
  motor_cx = cx_length / 2; // Centro do carrinho em X
  hole_left_x  = motor_cx - motor_flange_dist/2;  // -3.5
  hole_right_x = motor_cx + motor_flange_dist/2;  // 31.5

  // Socket para o trilho Y (abertura superior)
  socket_w = 10.0;  // largura do encaixe em X
  socket_d = 10.0;  // profundidade em Y
  socket_h = 6.0;   // altura do encaixe em Z

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

    // ====== REBAIXO PARA O CORPO DO MOTOR ======
    translate([motor_cx, motor_y_local + 2.0, motor_z_local])
      rotate([-90, 0, 0])
        cylinder(r=motor_body_r + 0.5, h=motor_body_h + 5);

    // ====== SOCKET PARA O TRILHO Y ======
    // Encaixe retangular no topo do carrinho (face Z+)
    translate([cx_length/2 - socket_w/2, cx_width/2 - socket_d/2, cx_height - socket_h])
      cube([socket_w, socket_d, socket_h + EPS]);
  }
}

// Renderização para impressão/exportação
carrinho_x();
