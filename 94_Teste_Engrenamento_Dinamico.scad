/*
  Teste CSG de engrenamento durante um passo completo (4 mm).
  Resultado correto: somente o cubo marcador de 1 mm em [500,500,0].
  Qualquer outro volume indica interpenetracao pinhao/cremalheira.
*/

include <00_Parametros.scad>;

translate([500,500,0]) cube([1,1,1]);

mesh_z = rack_pitch_height+gear_pitch_radius+gear_mesh_clearance;
samples = 16;

// X real: centro de 36 a 40 mm; eixo do pinhao em +Y.
for (i=[0:samples]) {
  p = X_MIN+i*rack_pitch/samples;
  translate([0,i*12,0]) intersection() {
    rack_x(48);
    translate([p,-pinion_thickness/2,mesh_z])
      rotate([-90,0,0])
        rotate([0,0,pinion_angle(p,+1,pinion_phase_x)])
        pinion_gear();
  }
}

// Y real: o centro do pinhao fica 14 mm depois da ponta da caneta.
for (i=[0:samples]) {
  p = Y_MIN+14+i*rack_pitch/samples;
  translate([100,i*12,0]) intersection() {
    rack_y(64);
    translate([-pinion_thickness/2,p,mesh_z])
      rotate([0,90,0])
        rotate([0,0,pinion_angle(p,-1,pinion_phase_y)])
        pinion_gear();
  }
}

// Z: a cremalheira se desloca; o pinhao permanece em altura fixa.
for (i=[0:samples]) {
  p = i*rack_pitch/samples;
  translate([200,i*12,0]) intersection() {
    translate([0,0,z_plunger_down_z-y_beam_top_z+z_rack_start+p])
      rack_z(28);
    translate([mesh_z,-pinion_thickness/2,z_motor_axis_z_local])
      rotate([-90,0,0])
        rotate([0,0,pinion_angle(p,+1,pinion_phase_z)])
        pinion_gear();
  }
}
