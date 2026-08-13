/*
  =============================================================================
  00_Parametros.scad - Centralizador Global (GEOMETRIA CORRIGIDA DEFINITIVA)
  =============================================================================
  Todas as constantes, folgas FDM e módulos geométricos compartilhados.
  
  CORREÇÕES APLICADAS:
  - dovetail_male/female reescritos com orientação inequívoca (_x e _y), min Z = 0
  - rack_x / rack_y / rack_z canônicos com base sólida (0.6mm) + hull()
  - pinion_gear com dentes que ultrapassam o pitch circle (addendum correto)
  - d_shaft_solid / d_shaft_hole unificados para motor e pinhão
  - Overlap controlado em uniões para solidez 100% 1-manifold sem componentes soltos
  =============================================================================
*/

$fn = 50;

// =============================================================================
// 1. CONSTANTES E TOLERÂNCIAS FDM
// =============================================================================
EPS = 0.01; // Overlap mínimo para uniões booleanas (evita coplanaridade)

slide_clearance_xy = 0.25; // Folga por lado nos eixos X/Y (validar no cupom 99)
slide_clearance_z  = 0.20; // Folga por lado no carro Z retangular
pressfit_clearance = 0.15; // Folga para prensagem justa (mm)
shaft_clearance    = 0.10; // Folga do eixo D do motor (mm)

wall_thin       = 2.4; // Parede fina comum (mm)
wall_structural = 2.8; // Parede estrutural (mm)
wall_screw      = 4.5; // Boss ao redor de parafusos M3 (mm)

// =============================================================================
// 2. MOTOR 28BYJ-48 5V DC
// =============================================================================
motor_body_diameter  = 28.2;
motor_mount_spacing  = 35.0;
motor_shaft_diameter = 5.0;  // Diâmetro nominal do eixo (mm)
motor_shaft_flat     = 3.0;  // Dimensão total do corte D (mm)
motor_shaft_length   = 9.0;

motor_body_r        = motor_body_diameter / 2;
motor_body_h        = 19.0;
motor_flange_dist   = motor_mount_spacing;
motor_flange_hole_r = 1.6;
motor_boss_r        = 4.6;
motor_boss_h        = 1.5;
motor_shaft_r       = motor_shaft_diameter / 2; // 2.50mm

// =============================================================================
// 3. DIMENSÕES DA MÁQUINA
// =============================================================================
x_rail_length = 200.0;
y_rail_length = 196.0;
base_w        = 30.0;  // Largura da base X no eixo Y
base_h        = 10.0;  // Altura estrutural da base X
floor_h       = 3.0;   // Espessura do piso da base X

// =============================================================================
// 4. ENGRENAGENS: CREMALHEIRA E PINHÃO
// =============================================================================
rack_pitch        = 4.0;
gear_teeth        = 10;
gear_pitch_radius = (gear_teeth * rack_pitch) / (2 * PI); // ≈6.366mm

tooth_height = 2.2;  // Altura do dente da cremalheira (mm)
// Larguras do dente da cremalheira (perfil trapezoidal canônico):
rack_tooth_base_hw = rack_pitch / 3;   // meia-largura na base = 1.333mm
rack_tooth_tip_hw  = rack_pitch / 6;   // meia-largura na ponta = 0.667mm

// Pinhão: addendum/dedendum derivados de tooth_height
gear_addendum     = tooth_height * 0.55;  // Acima do pitch circle
gear_dedendum     = tooth_height * 0.55;  // Abaixo do pitch circle
gear_root_radius  = gear_pitch_radius - gear_dedendum;  // ≈5.16mm
gear_tip_radius   = gear_pitch_radius + gear_addendum;  // ≈7.58mm
gear_outer_radius = gear_tip_radius; // Raio externo REAL do STL

gear_backlash   = 0.20;
rack_width      = 4.0;  // Largura transversal padrão da cremalheira
pinion_thickness = 7.0;

// Largura tangencial dos dentes do pinhão (no pitch circle ≈ pitch/2 - backlash)
pinion_tooth_width_pitch = rack_pitch / 2 - gear_backlash; // 1.80mm

// =============================================================================
// 5. GUIAS RABO DE ANDORINHA
// =============================================================================
dovetail_height       = 4.5;
dovetail_width_bottom = 9.5;   // Pescoço (base estreita)
dovetail_width_top    = 13.0;  // Topo (aba larga)

// =============================================================================
// 6. EIXO Z
// =============================================================================
active_z_travel   = 6.0;
compliance_travel = 3.0;
pen_diameter      = 10.0;
pen_clearance     = 0.25;
// A mola envolve a caneta; portanto seu DI deve ser maior que pen_diameter.
spring_inner_diameter = 10.8;
spring_outer_diameter = 13.0;
spring_length         = 14.0;
spring_rate_target    = 0.20; // N/mm; alvo para 0.2 N de pre-carga e 0.8 N no fim
spring_preload        = 1.0;  // compressao inicial em mm

// Carro Z anti-rotacao e coordenadas compartilhadas com carrinho/montagem.
z_carriage_w       = 13.0;
z_carriage_d       = 13.0;
z_carriage_body_h  = 22.0;
z_axis_center_x    = 8.5;
z_axis_center_y    = 11.0; // libera a placa frontal do motor Z; 3mm de eixo no pinhao
z_rack_start       = 17.0;
z_rack_length      = active_z_travel + 8.0;
z_motor_axis_x     = z_axis_center_x + z_carriage_w/2 + tooth_height/2 + gear_pitch_radius;
z_motor_axis_z     = tooth_height/2 + gear_pitch_radius + 15.5; // separa os pinhoes Y/Z

// Chaveta estrutural entre o carrinho X e o trilho Y.
y_mount_tongue_w = 18.0;
y_mount_tongue_d = 14.0;
y_mount_tongue_h = 6.0; // profundidade no carrinho X
y_mount_upper_socket_h = 5.0;
y_mount_key_h = y_mount_tongue_h + y_mount_upper_socket_h - 0.2;
y_mount_boss_h = 8.0;

// =============================================================================
// 7. ÁREA DE TRABALHO
// =============================================================================
paper_width  = 148.0;
paper_height = 210.0;
paper_z      = 0.0;

X_MIN = 4.0;
X_MAX = 168.0;
Y_MIN = 0.0;
Y_MAX = 138.0;
Z_UP   = active_z_travel;
Z_DOWN = 0.0;

// =============================================================================
// 8. OPÇÕES DE VISUALIZAÇÃO
// =============================================================================
SHOW_DEBUG            = false;
SHOW_MOTORS           = true;
SHOW_PITCH_LINES      = false;
SHOW_WORK_AREA        = false;
SHOW_CLEARANCE        = false;
SHOW_LEGACY_REFERENCE = false;
EXPLODED_VIEW         = 0.0;

// #############################################################################
//                    MÓDULOS GEOMÉTRICOS COMPARTILHADOS
// #############################################################################

// =============================================================================
// DOVETAIL MACHO/FÊMEA (ORIENTAÇÃO INEQUÍVOCA POR EIXO, min Z = 0)
// =============================================================================

module dovetail_male_x(length, height=dovetail_height, neck=dovetail_width_bottom, top=dovetail_width_top) {
  // Guia macho ao longo de X. Z de 0 a height.
  rotate([90, 0, 90])
    linear_extrude(height=length)
      polygon(points=[
        [-neck/2, 0],
        [-top/2,  height],
        [ top/2,  height],
        [ neck/2, 0]
      ]);
}

module dovetail_female_x(length, height=dovetail_height, neck=dovetail_width_bottom, top=dovetail_width_top, clearance=slide_clearance_xy) {
  c_neck = neck + clearance * 2;
  c_top  = top  + clearance * 2;
  c_h    = height + clearance;

  rotate([90, 0, 90])
    translate([0, 0, -EPS])
      linear_extrude(height=length + EPS * 2)
        polygon(points=[
          [-c_neck/2, -clearance],
          [-c_top/2,  c_h],
          [ c_top/2,  c_h],
          [ c_neck/2, -clearance]
        ]);
}

module dovetail_male_y(length, height=dovetail_height, neck=dovetail_width_bottom, top=dovetail_width_top) {
  // Guia macho ao longo de Y. Z de 0 a height.
  translate([0, length, 0])
    rotate([90, 0, 0])
      linear_extrude(height=length)
        polygon(points=[
          [-neck/2, 0],
          [-top/2,  height],
          [ top/2,  height],
          [ neck/2, 0]
        ]);
}

module dovetail_female_y(length, height=dovetail_height, neck=dovetail_width_bottom, top=dovetail_width_top, clearance=slide_clearance_xy) {
  c_neck = neck + clearance * 2;
  c_top  = top  + clearance * 2;
  c_h    = height + clearance;

  translate([0, length + EPS, 0])
    rotate([90, 0, 0])
      linear_extrude(height=length + EPS * 2)
        polygon(points=[
          [-c_neck/2, -clearance],
          [-c_top/2,  c_h],
          [ c_top/2,  c_h],
          [ c_neck/2, -clearance]
        ]);
}

// =============================================================================
// CREMALHEIRAS CANÔNICAS (com base de união contínua de 0.6mm para 100% de solidez)
// =============================================================================

module rack_x(length, pitch=rack_pitch, height=tooth_height, width=rack_width) {
  // Cremalheira ao longo de X. Base contínua em Z=[-0.6, 0] para interpenetração sólida.
  num_teeth = floor(length / pitch);
  union() {
    translate([0, -width/2, -0.6])
      cube([length, width, 0.6 + EPS]);
    
    for (i = [0 : num_teeth - 1]) {
      translate([(i + 0.5) * pitch, 0, 0])
        hull() {
          cube([2 * rack_tooth_base_hw, width, EPS], center=true);
          translate([0, 0, height])
            cube([2 * rack_tooth_tip_hw, width, EPS], center=true);
        }
    }
  }
}

module rack_y(length, pitch=rack_pitch, height=tooth_height, width=rack_width) {
  // Cremalheira ao longo de Y. Base contínua em Z=[-0.6, 0] para interpenetração sólida.
  num_teeth = floor(length / pitch);
  union() {
    translate([-width/2, 0, -0.6])
      cube([width, length, 0.6 + EPS]);

    for (i = [0 : num_teeth - 1]) {
      translate([0, (i + 0.5) * pitch, 0])
        hull() {
          cube([width, 2 * rack_tooth_base_hw, EPS], center=true);
          translate([0, 0, height])
            cube([width, 2 * rack_tooth_tip_hw, EPS], center=true);
        }
    }
  }
}

module rack_z(length, pitch=rack_pitch, height=tooth_height, width=rack_width) {
  // Cremalheira ao longo de Z. Base contínua em X=[-0.6, 0] para interpenetração sólida no êmbolo.
  num_teeth = floor(length / pitch);
  union() {
    translate([-0.6, -width/2, 0])
      cube([0.6 + EPS, width, length]);

    for (i = [0 : num_teeth - 1]) {
      translate([0, 0, (i + 0.5) * pitch])
        hull() {
          cube([EPS, width, 2 * rack_tooth_base_hw], center=true);
          translate([height, 0, 0])
            cube([EPS, width, 2 * rack_tooth_tip_hw], center=true);
        }
    }
  }
}

// =============================================================================
// PINHÃO
// =============================================================================

module pinion_gear(teeth=gear_teeth, pitch=rack_pitch, thickness=pinion_thickness) {
  r_pitch = (teeth * pitch) / (2 * PI);
  r_root  = r_pitch - gear_dedendum;
  r_tip   = r_pitch + gear_addendum;
  tooth_root_r = r_root - 0.25; // overlap radial evita uniao apenas coplanar

  tw_root = pinion_tooth_width_pitch * 1.35;
  tw_tip  = pinion_tooth_width_pitch * 0.65;

  difference() {
    union() {
      cylinder(r=r_root, h=thickness);
      for (i = [0 : teeth - 1]) {
        rotate([0, 0, i * (360 / teeth)])
          linear_extrude(height=thickness)
            polygon(points=[
              [tooth_root_r,  -tw_root/2],
              [r_tip,   -tw_tip/2],
              [r_tip,    tw_tip/2],
              [tooth_root_r,   tw_root/2]
            ]);
      }
    }
    translate([0, 0, -EPS])
      d_shaft_hole(h=thickness + EPS * 2);
  }
}

// =============================================================================
// EIXO D UNIFICADO
// =============================================================================

module d_shaft_solid(h=10.0) {
  flat_dist = motor_shaft_flat - motor_shaft_r;
  difference() {
    cylinder(r=motor_shaft_r, h=h);
    translate([flat_dist, -(motor_shaft_r + 1), -EPS])
      cube([(motor_shaft_r + 1) * 2, (motor_shaft_r + 1) * 2, h + EPS * 2]);
  }
}

module d_shaft_hole(h=10.0, clearance=shaft_clearance) {
  r_c = motor_shaft_r + clearance;
  flat_dist_c = (motor_shaft_flat - motor_shaft_r) + clearance;
  difference() {
    cylinder(r=r_c, h=h);
    translate([flat_dist_c, -(r_c + 1), -EPS])
      cube([(r_c + 1) * 2, (r_c + 1) * 2, h + EPS * 2]);
  }
}

// =============================================================================
// LEGADO: aliases para compatibilidade
// =============================================================================
module dovetail_male(length, height=dovetail_height, neck=dovetail_width_bottom, top=dovetail_width_top) {
  dovetail_male_x(length, height, neck, top);
}
module dovetail_female(length, height=dovetail_height, neck=dovetail_width_bottom, top=dovetail_width_top, clearance=slide_clearance_xy) {
  dovetail_female_x(length, height, neck, top, clearance);
}
module motor_d_shaft_hole(h=10.0, clearance=shaft_clearance) {
  d_shaft_hole(h, clearance);
}
