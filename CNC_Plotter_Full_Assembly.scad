/*
  Montagem completa — dois trilhos X, uma viga Y apoiada e sapata passiva.
  pos_x e pos_y representam diretamente a posicao da ponta da caneta.
*/

include <00_Parametros.scad>;
use <01_Base_Trilho_X.scad>;
use <02_Carrinho_X.scad>;
use <03_Trilho_Y.scad>;
use <04_Carrinho_Y.scad>;
use <05_Modulo_Z_Caneta.scad>;
use <90_Componentes_Referencia.scad>;

module cnc_plotter_assembly(
  pos_x=(X_MIN+X_MAX)/2,
  pos_y=(Y_MIN+Y_MAX)/2,
  pos_z=Z_UP,
  show_motors=true,
  show_fasteners=true,
  show_paper=true,
  show_legacy=false,
  show_debug=false,
  exploded=0,
  passive_rail_error=0
) {
  assert(pos_x >= X_MIN && pos_x <= X_MAX,"X fora do curso util");
  assert(pos_y >= Y_MIN && pos_y <= Y_MAX,"Y fora do curso util");
  assert(pos_z >= Z_DOWN && pos_z <= Z_UP,"Z fora do curso util");
  assert(abs(passive_rail_error) <= passive_float,
         "Desalinhamento excede o curso da sapata flutuante");

  front_rail_y = -base_w/2;
  rear_rail_y  = x_rail_spacing-base_w/2+passive_rail_error;
  carriage_x0  = pos_x-x_carriage_length/2;
  motor_x_axis_z = base_h+rack_pitch_height
                   + gear_pitch_radius+gear_mesh_clearance;

  // 1. Trilhos fixos. Somente o dianteiro e acionado.
  color([0.18,0.21,0.24]) translate([0,front_rail_y,0])
    trilho_x_motriz();
  color([0.18,0.21,0.24]) translate([0,rear_rail_y,0])
    trilho_x_passivo();

  // 2. Carrinho dianteiro motriz.
  color([0.28,0.34,0.39])
    translate([carriage_x0,front_rail_y,base_h])
      carrinho_x_motriz();

  color([1.0,0.50,0.08,1.0])
    translate([pos_x,front_rail_y+x_rack_center_y-pinion_thickness/2,
               motor_x_axis_z])
      rotate([-90,0,0])
        rotate([0,0,pinion_angle(pos_x,+1,pinion_phase_x)])
        pinion_gear();

  if (show_motors)
    translate([pos_x,front_rail_y-motor_x_mount_standoff,motor_x_axis_z])
      orient_motor_x() motor_28byj48_reference();

  // 3. Apoio traseiro: a sapata acompanha eventual erro do trilho; sela e
  // viga permanecem geometricamente esquadrejadas ao conjunto dianteiro.
  color([0.12,0.52,0.55])
    translate([carriage_x0,rear_rail_y,base_h]) sapata_x_passiva();
  color([0.30,0.36,0.41])
    translate([carriage_x0,x_rail_spacing-base_w/2,
               base_h+passive_shoe_h]) sela_x_passiva();

  // 4. Viga-caixao Y, apoiada e travada nas duas pontas.
  color([0.22,0.27,0.31])
    translate([pos_x,0,y_beam_bottom_z]) trilho_y();

  // 5. Carrinho Y. O zero local e deslocado para que pos_y seja a ponta.
  cy_x0 = pos_x+y_dovetail_center_x-y_carriage_w/2;
  cy_y0 = pos_y-z_axis_center_y_local;
  motor_y_axis_z = y_beam_top_z+rack_pitch_height
                   + gear_pitch_radius+gear_mesh_clearance;
  motor_y_axis_y = cy_y0+y_carriage_length/2;

  color([0.30,0.36,0.41])
    translate([cy_x0,cy_y0,y_beam_top_z]) carrinho_y();

  color([1.0,0.50,0.08,1.0])
    translate([pos_x+y_rack_center_x-pinion_thickness/2,
               motor_y_axis_y,motor_y_axis_z])
      rotate([0,90,0])
        rotate([0,0,pinion_angle(motor_y_axis_y,-1,pinion_phase_y)])
        pinion_gear();

  if (show_motors)
    translate([cy_x0+y_carriage_w,motor_y_axis_y,motor_y_axis_z])
      orient_motor_y() motor_28byj48_reference();

  // 6. Z complacente. A compressao desaparece progressivamente ao levantar.
  z_compression = nominal_compression*(1-pos_z/Z_UP);
  plunger_x = cy_x0+z_axis_center_x_local;
  plunger_y = pos_y;
  plunger_z = z_plunger_down_z+pos_z;

  translate([plunger_x,plunger_y,plunger_z])
    modulo_z_pen_assembly(compression=z_compression,show_pen=true);

  pz_x = cy_x0+z_motor_axis_x_local;
  pz_z = y_beam_top_z+z_motor_axis_z_local;
  color([1.0,0.50,0.08,1.0])
    translate([pz_x,plunger_y-pinion_thickness/2,pz_z])
      rotate([-90,0,0])
        rotate([0,0,pinion_angle(pos_z,+1,pinion_phase_z)])
        pinion_gear();

  if (show_motors)
    translate([pz_x,cy_y0,pz_z])
      orient_motor_z() motor_28byj48_reference();

  if (show_fasteners) {
    // Parafusos dos motores: dois por motor.
    for (dx=[-motor_flange_dist/2,motor_flange_dist/2])
      translate([pos_x+dx,front_rail_y-motor_x_mount_standoff,motor_x_axis_z])
        orient_motor_x() m3_screw_reference(7);
    for (dy=[-motor_flange_dist/2,motor_flange_dist/2])
      translate([cy_x0+y_carriage_w,motor_y_axis_y+dy,motor_y_axis_z])
        orient_motor_y() m3_screw_reference(7);
    for (dx=[-motor_flange_dist/2,motor_flange_dist/2])
      translate([pz_x+dx,cy_y0,pz_z])
        orient_motor_z() m3_screw_reference(7);

    // Um M3 por ponta da viga e um M3 com ombro na sapata passiva.
    translate([pos_x,0, y_beam_bottom_z+beam_key_h/2])
      rotate([-90,0,0]) m3_screw_reference(10);
    translate([pos_x,x_rail_spacing,
               y_beam_bottom_z+beam_key_h/2])
      rotate([90,0,0]) m3_screw_reference(10);
    translate([pos_x,x_rail_spacing,base_h+passive_shoe_h+passive_saddle_h])
      m3_screw_reference(8);
  }

  if (show_paper) {
    color([0.98,0.98,0.93,0.72])
      translate([paper_origin_x,paper_origin_y,paper_z])
        cube([paper_width,paper_height,paper_thickness]);
    if (show_debug)
      color([0.2,0.75,0.3,0.25])
        translate([X_MIN,Y_MIN,paper_z+paper_thickness+0.01])
          cube([X_MAX-X_MIN,Y_MAX-Y_MIN,0.05]);
  }
}

cnc_plotter_assembly();
