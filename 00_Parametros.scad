/*
  Parametros globais — portico apoiado em dois trilhos X.

  Sistema de coordenadas da montagem:
    X = largura do desenho / deslocamento do portico
    Y = comprimento do papel / deslocamento do carrinho da caneta
    Z = vertical; superficie da bancada em Z=0

  Materiais previstos:
    PLA  : trilhos, viga-caixao e carrinhos rigidos
    PETG : sapata passiva flutuante do segundo trilho
*/

$fn = 50;
EPS = 0.01;

// Folgas por lado. Confirmadas nos testes físicos FDM.
slide_clearance_xy = 0.22; // Validado no Teste 99 (Par #3)
slide_clearance_z  = 0.15;
passive_float      = 0.60; // +/-0,60 mm transversal; 1,20 mm total
pressfit_clearance = 0.15;
shaft_clearance    = 0.18; // Validado no Teste de Eixo D (#1)



wall_thin       = 1.80;
wall_structural = 2.40;
wall_screw      = 4.50;

// Motor 28BYJ-48 (Dimensões oficiais Datasheet Mouser/Kiatronics)
motor_body_diameter  = 28.0; // Datasheet: 28 mm
motor_mount_spacing  = 35.0; // Datasheet: 35 +/- 0.2 mm
motor_shaft_diameter = 5.0;  // Datasheet: phi 5.0 (0 a -0.1 mm) -> r = 2.5 mm
motor_shaft_flat     = 3.0;  // Datasheet: 3.0 (0 a -0.1 mm) espessura da seção D
motor_shaft_flat_len = 6.0;  // Datasheet: 6.0 +/- 0.2 mm comprimento útil do D
motor_shaft_length   = 8.5;  // Datasheet: 10.0 - 1.5 = 8.5 mm livre da base
motor_body_r         = motor_body_diameter / 2;
motor_body_h         = 19.0; // Datasheet: 19.0 mm
motor_flange_dist    = motor_mount_spacing;
motor_flange_hole_r  = 2.1;  // Datasheet: 2-phi 4.2 +/- 0.15 mm
motor_flange_outer_r = 3.5;  // Datasheet: 2-R3.5 mm
motor_flange_thickness = 1.0;
motor_boss_r         = 4.5;  // Datasheet: phi 9.0 mm -> r = 4.5 mm
motor_boss_h         = 1.5;  // Datasheet: 1.5 mm
motor_shaft_r        = motor_shaft_diameter / 2;
motor_mount_clearance = 0.25;
motor_x_mount_standoff = 3.3;


// Estrutura fixa X. Os centros dos trilhos ficam em Y=0 e Y=x_rail_spacing.
x_rail_length     = 220.0;
x_rail_spacing    = 240.0;
base_w            = 26.0;
base_h            = 10.0;
floor_h           = 2.4;
x_rack_center_y   = 2.8; // lado externo; pinhao livre da guia central
x_carriage_length = 56.0;
x_carriage_h      = 12.0;
passive_shoe_h    = 8.0;
passive_saddle_h  = x_carriage_h - passive_shoe_h;
passive_boss_w    = 18.0;
passive_boss_d    = 8.0;
passive_boss_h    = 3.0;

// Viga Y: tubo fechado com diafragmas.
y_rail_length         = x_rail_spacing;
y_beam_w              = 30.0;
y_beam_h              = 24.0;
y_beam_wall           = 1.80;
y_beam_rib_pitch      = 40.0;
y_beam_rib_t          = 1.80;
y_dovetail_center_x   = -5.5;
y_rack_center_x       = 10.0;
beam_key_w            = 20.0;
beam_key_d            = 16.0;
beam_key_h            = 4.0;
beam_key_inset        = y_beam_wall;
beam_socket_clearance = 0.20;
beam_mount_hole_r     = 1.65; // M3

// Cremalheira e pinhao impressos
rack_pitch        = 4.0;
gear_teeth        = 10;
gear_pitch_radius = (gear_teeth * rack_pitch) / (2 * PI);
gear_module        = rack_pitch / PI;
gear_pressure_angle = 30.0;
gear_addendum      = 0.80 * gear_module;
gear_dedendum      = 1.00 * gear_module;
tooth_height       = gear_addendum + gear_dedendum;
rack_pitch_height  = gear_dedendum;
rack_tooth_base_hw = rack_pitch/4
                     + gear_dedendum*tan(gear_pressure_angle);
rack_tooth_tip_hw  = rack_pitch/4
                     - gear_addendum*tan(gear_pressure_angle);
gear_root_radius   = gear_pitch_radius - gear_dedendum;
gear_tip_radius    = gear_pitch_radius + gear_addendum;
gear_outer_radius  = gear_tip_radius;
gear_backlash      = 0.20;
gear_mesh_clearance = 0.15;
// Folga do bolso, sem alterar a distancia de engrenamento. Os valores incluem
// margem para pe de elefante, leve empenamento e excentricidade de impressao.
pinion_pocket_radial_clearance = 0.70;
pinion_pocket_axial_clearance  = 0.60;
// Sobrepoe a raiz de cada dente ao disco central. Sem esta intersecao real,
// o preview OpenCSG exibe faces coplanares como se o pinhao fosse transparente.
gear_tooth_root_overlap = 0.20;
rack_width         = 4.0;
pinion_thickness   = 7.0;
pinion_tooth_width_pitch = rack_pitch / 2 - gear_backlash;
pinion_phase_x     = 18.0;
pinion_phase_y     = 0.0;
pinion_phase_z     = 18.0;
pinion_phase_deg   = pinion_phase_x;

// Guia rabo de andorinha
dovetail_height       = 4.5;
dovetail_width_bottom = 9.5;
dovetail_width_top    = 13.0;

// Carrinho Y e Z
y_carriage_w      = 44.0;
y_carriage_length = 48.0;
y_carriage_h      = 14.0;
z_guide_total_h   = 22.0;
z_axis_center_x_local = 10.0;
z_axis_center_y_local = 10.0;

z_motor_travel       = 8.0;
pen_lift_clearance   = 6.0;
nominal_compression  = 2.0;
compliance_travel    = 3.0;
// O mecanismo Z guia uma haste padrao de 10 mm. A ferramenta real fica em um
// mandril externo com buchas, portanto caneta e pincel nao precisam ter 10 mm.
tool_carrier_stem_diameter = 10.0;
pen_diameter         = tool_carrier_stem_diameter; // compatibilidade
pen_clearance        = 0.25;
spring_inner_diameter = 10.8;
spring_outer_diameter = 13.0;
spring_length         = 14.0;
spring_rate_target    = 0.20;
spring_preload        = 1.0;

tool_holder_bore_diameter = 15.5;
tool_holder_outer_diameter = 22.0;
tool_holder_height    = 24.0;
tool_holder_grip_h    = 16.0;
tool_holder_slit      = 1.20;
tool_holder_top_gap   = 4.0;
tool_carrier_stem_length = 48.0;
tool_sleeve_outer_diameter = 15.2;
tool_sleeve_height    = 15.5;
tool_sleeve_clearance = 0.25;
tool_sleeve_sizes     = [7.5,10.0,12.5];

z_carriage_w      = 13.0;
z_carriage_d      = 13.0;
z_carriage_body_h = 22.0;
z_collar_od       = 13.0;
z_collar_h        = 4.0;
z_cage_w          = 20.4;
z_cage_d          = 13.0;
z_post_w          = 3.8;
z_cap_h           = 3.0;
z_cap_bottom      = z_carriage_body_h + z_collar_h
                    + spring_length - spring_preload;
z_rack_start      = 2.0;
z_rack_length     = z_motor_travel + 16.0;
z_rack_base_x     = z_cage_w/2 - 0.20;
z_mesh_clearance  = gear_mesh_clearance;
z_pinion_offset_x = z_rack_base_x + rack_pitch_height
                    + gear_pitch_radius + z_mesh_clearance;
z_motor_axis_x_local = z_axis_center_x_local + z_pinion_offset_x;
z_motor_axis_z_local = 20.5;

// Planos globais da montagem
paper_width       = 148.0;
paper_height      = 210.0;
paper_z           = 0.0;
paper_thickness   = 0.30;
paper_origin_x    = 36.0;
paper_origin_y    = 15.0;
y_beam_bottom_z   = base_h + x_carriage_h;
y_beam_top_z      = y_beam_bottom_z + y_beam_h;
z_plunger_down_z  = y_beam_top_z + 0.50;
pen_tip_uncompressed_z = paper_z + paper_thickness
                         - z_plunger_down_z - nominal_compression;

// Curso conservador: cobre 148 x 180 mm dentro de uma folha A5.
X_MIN = paper_origin_x;
X_MAX = paper_origin_x + paper_width;
Y_MIN = paper_origin_y + 15.0;
Y_MAX = paper_origin_y + paper_height - 15.0;
Z_DOWN = 0.0;
Z_UP   = z_motor_travel;

SHOW_DEBUG       = false;
SHOW_MOTORS      = true;
SHOW_WORK_AREA   = false;
EXPLODED_VIEW    = 0.0;

// Uma volta corresponde a gear_teeth*rack_pitch (40 mm para 10T x 4 mm).
function pinion_angle(linear_position, direction=-1,
                      phase=pinion_phase_deg) =
  phase + direction * linear_position * 360
          / (gear_teeth*rack_pitch);

module dovetail_male_x(length, height=dovetail_height,
                       neck=dovetail_width_bottom, top=dovetail_width_top) {
  rotate([90,0,90]) linear_extrude(height=length)
    polygon(points=[[-neck/2,0],[-top/2,height],
                    [ top/2,height],[ neck/2,0]]);
}

module dovetail_female_x(length, height=dovetail_height,
                         neck=dovetail_width_bottom, top=dovetail_width_top,
                         clearance=slide_clearance_xy) {
  c_neck = neck + 2*clearance;
  c_top  = top  + 2*clearance;
  c_h    = height + clearance;
  rotate([90,0,90]) translate([0,0,-EPS])
    linear_extrude(height=length+2*EPS)
      polygon(points=[[-c_neck/2,-clearance],[-c_top/2,c_h],
                      [ c_top/2,c_h],[ c_neck/2,-clearance]]);
}

module dovetail_male_y(length, height=dovetail_height,
                       neck=dovetail_width_bottom, top=dovetail_width_top) {
  translate([0,length,0]) rotate([90,0,0]) linear_extrude(height=length)
    polygon(points=[[-neck/2,0],[-top/2,height],
                    [ top/2,height],[ neck/2,0]]);
}

module dovetail_female_y(length, height=dovetail_height,
                         neck=dovetail_width_bottom, top=dovetail_width_top,
                         clearance=slide_clearance_xy) {
  c_neck = neck + 2*clearance;
  c_top  = top  + 2*clearance;
  c_h    = height + clearance;
  translate([0,length+EPS,0]) rotate([90,0,0])
    linear_extrude(height=length+2*EPS)
      polygon(points=[[-c_neck/2,-clearance],[-c_top/2,c_h],
                      [ c_top/2,c_h],[ c_neck/2,-clearance]]);
}

module rack_x(length, pitch=rack_pitch, height=tooth_height, width=rack_width) {
  n = floor(length/pitch);
  union() {
    translate([0,-width/2,-0.6]) cube([length,width,0.6+EPS]);
    for (i=[0:n-1]) translate([(i+0.5)*pitch,0,0]) hull() {
      cube([2*rack_tooth_base_hw,width,EPS],center=true);
      translate([0,0,height]) cube([2*rack_tooth_tip_hw,width,EPS],center=true);
    }
  }
}

module rack_y(length, pitch=rack_pitch, height=tooth_height, width=rack_width) {
  n = floor(length/pitch);
  union() {
    translate([-width/2,0,-0.6]) cube([width,length,0.6+EPS]);
    for (i=[0:n-1]) translate([0,(i+0.5)*pitch,0]) hull() {
      cube([width,2*rack_tooth_base_hw,EPS],center=true);
      translate([0,0,height]) cube([width,2*rack_tooth_tip_hw,EPS],center=true);
    }
  }
}

module rack_z(length, pitch=rack_pitch, height=tooth_height, width=rack_width) {
  n = floor(length/pitch);
  union() {
    translate([-0.6,-width/2,0]) cube([0.6+EPS,width,length]);
    for (i=[0:n-1]) translate([0,0,(i+0.5)*pitch]) hull() {
      cube([EPS,width,2*rack_tooth_base_hw],center=true);
      translate([height,0,0]) cube([EPS,width,2*rack_tooth_tip_hw],center=true);
    }
  }
}

module pinion_profile_solid(teeth=gear_teeth, pitch=rack_pitch) {
  r_pitch = teeth*pitch/(2*PI);
  r_root  = r_pitch - gear_dedendum;
  r_tip   = r_pitch + gear_addendum;
  r_base  = r_pitch*cos(gear_pressure_angle);
  inv_pitch = tan(gear_pressure_angle)*180/PI-gear_pressure_angle;
  half_pitch_angle = pinion_tooth_width_pitch/(2*r_pitch)*180/PI;
  flank_offset = half_pitch_angle+inv_pitch;
  root_anchor = r_root-gear_tooth_root_overlap;
  steps = 7;

  assert(gear_tooth_root_overlap > 0
         && gear_tooth_root_overlap < r_root,
         "Sobreposicao da raiz do dente fora do intervalo valido");

  function involute_angle(r) =
    let(t=sqrt((r/r_base)*(r/r_base)-1)) t*180/PI-atan(t);
  function flank_angle(r) = flank_offset-involute_angle(r);

  lower_flank = [for (j=[0:steps])
    let(r=r_base+(r_tip-r_base)*j/steps,a=-flank_angle(r))
      [r*cos(a),r*sin(a)]];
  upper_flank = [for (j=[steps:-1:0])
    let(r=r_base+(r_tip-r_base)*j/steps,a=flank_angle(r))
      [r*cos(a),r*sin(a)]];
  tip_a = flank_angle(r_tip);
  tip_arc = [for (j=[1:3])
    let(a=-tip_a+2*tip_a*j/4) [r_tip*cos(a),r_tip*sin(a)]];
  tooth_polygon = concat(
    // Os pontos de ancoragem ficam dentro do disco de raiz. A sobreposicao
    // elimina a costura coplanar que causava artefatos de transparencia no F5.
    [[root_anchor*cos(-flank_offset),root_anchor*sin(-flank_offset)]],
    lower_flank,tip_arc,upper_flank,
    [[root_anchor*cos(flank_offset),root_anchor*sin(flank_offset)]]
  );

  union() {
    circle(r=r_root);
    for (i=[0:teeth-1]) rotate(i*360/teeth)
      polygon(points=tooth_polygon);
  }
}

module rack_profile_linear(length, pitch=rack_pitch) {
  n = floor(length/pitch);
  union() {
    translate([0,-0.6]) square([length,0.6+EPS]);
    for (i=[0:n-1])
      translate([(i+0.5)*pitch,0])
        polygon(points=[[-rack_tooth_base_hw,0],
                        [-rack_tooth_tip_hw,tooth_height],
                        [ rack_tooth_tip_hw,tooth_height],
                        [ rack_tooth_base_hw,0]]);
  }
}

module pinion_gear(teeth=gear_teeth, pitch=rack_pitch,
                   thickness=pinion_thickness, clearance=shaft_clearance) {
  // Forca uma malha CGAL antes de devolver o pinhao ao preview. No OpenSCAD
  // 2021, o OpenCSG mostra as unioes dos dentes com faces escuras/vazadas no
  // F5 mesmo quando o STL final e valido. render() elimina esse artefato.
  render(convexity=10)
    difference() {
      linear_extrude(height=thickness)
        pinion_profile_solid(teeth,pitch);
      translate([0,0,-EPS]) d_shaft_hole(h=thickness+2*EPS, clearance=clearance);
    }
}


module d_shaft_solid(h=10) {
  r = motor_shaft_r; // 2.5 mm
  d = motor_shaft_flat / 2; // 1.5 mm (espessura total de 3.0 mm entre as duas faces chatas)
  difference() {
    cylinder(r=r, h=h);
    // Corte plano superior
    translate([-r-1, d, -EPS])
      cube([(r+1)*2, r+2, h+2*EPS]);
    // Corte plano inferior
    translate([-r-1, -d - (r+2), -EPS])
      cube([(r+1)*2, r+2, h+2*EPS]);
  }
}

module d_shaft_hole(h=10, clearance=shaft_clearance, chamfer=0.6) {
  r_c = motor_shaft_r + clearance; // 2.5 + clearance
  d_c = (motor_shaft_flat / 2) + clearance; // 1.5 + clearance (espessura total de 3.0 + 2*clearance)
  
  union() {
    difference() {
      cylinder(r=r_c, h=h);
      // Corte plano superior
      translate([-r_c-1, d_c, -EPS])
        cube([(r_c+1)*2, r_c+2, h+2*EPS]);
      // Corte plano inferior
      translate([-r_c-1, -d_c - (r_c+2), -EPS])
        cube([(r_c+1)*2, r_c+2, h+2*EPS]);
    }
    // Entrada chanfrada na primeira camada (elimina pé de elefante da impressão FDM)
    if (chamfer > 0) {
      translate([0, 0, -EPS])
        cylinder(r1=r_c + chamfer, r2=r_c, h=chamfer + EPS);
    }
  }
}



// Compatibilidade com arquivos auxiliares antigos.
active_z_travel = z_motor_travel;
z_axis_center_x = z_axis_center_x_local;
z_axis_center_y = z_axis_center_y_local;
z_motor_axis_x  = z_motor_axis_x_local;
z_motor_axis_z  = z_motor_axis_z_local;
module dovetail_male(length,height=dovetail_height,
                     neck=dovetail_width_bottom,top=dovetail_width_top)
  dovetail_male_x(length,height,neck,top);
module dovetail_female(length,height=dovetail_height,
                       neck=dovetail_width_bottom,top=dovetail_width_top,
                       clearance=slide_clearance_xy)
  dovetail_female_x(length,height,neck,top,clearance);
module motor_d_shaft_hole(h=10,clearance=shaft_clearance)
  d_shaft_hole(h,clearance);
