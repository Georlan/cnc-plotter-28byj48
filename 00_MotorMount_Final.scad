/*
  Interface FINAL de fixacao do motor 28BYJ-48.

  O arquivo 00_Parametros.scad mantem a interface de calibracao com rasgos
  longos usada pelo cupom inicial. Depois da validacao fisica do motor real,
  as pecas de producao usam uma fixacao mais rigida:

    - ressalto frontal de 9 mm = datum coaxial do eixo;
    - orelha esquerda = furo redondo M3 de referencia;
    - orelha direita = rasgo curto para absorver tolerancia FDM;
    - altura do eixo e distancia pinhao/cremalheira NAO mudam.
*/

include <00_Parametros.scad>;

// +/-0,75 mm apenas na segunda orelha. O rasgo completo fica com 5,0 mm de
// comprimento usando o furo M3 de 3,5 mm, suficiente para tolerancia de
// impressao sem deixar o motor livre para migrar durante o uso.
motor_mount_final_slot_adjust = 0.75;

module motor_28byj48_mount_final_bridge_local(
  depth=motor_mount_pad_depth,
  pad_r=motor_mount_pad_r,
  slot_adjust=motor_mount_final_slot_adjust
) {
  hull() {
    // Apoio do furo redondo de referencia.
    translate([-motor_mount_spacing/2,-motor_mount_line_offset,0])
      cylinder(r=pad_r,h=depth);

    // Apoio da faixa curta de regulagem da segunda orelha.
    for (dx=[-slot_adjust,slot_adjust])
      translate([motor_mount_spacing/2+dx,-motor_mount_line_offset,0])
        cylinder(r=pad_r,h=depth);
  }
}

module motor_28byj48_mount_final_fasteners_local(
  depth=8.0,
  screw_r=motor_mount_screw_clearance_r,
  slot_adjust=motor_mount_final_slot_adjust
) {
  // Orelha esquerda: furo redondo. Com o boss central encaixado, este furo
  // elimina o grau de liberdade restante da flange sem reposicionar o eixo.
  translate([-motor_mount_spacing/2,-motor_mount_line_offset,-EPS])
    cylinder(r=screw_r,h=depth+2*EPS);

  // Orelha direita: rasgo curto apenas para tolerancia de impressao/fabricante.
  hull()
    for (dx=[-slot_adjust,slot_adjust])
      translate([motor_mount_spacing/2+dx,-motor_mount_line_offset,-EPS])
        cylinder(r=screw_r,h=depth+2*EPS);
}
