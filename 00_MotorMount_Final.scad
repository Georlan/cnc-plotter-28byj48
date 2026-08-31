/*
  Interface FINAL de fixacao do motor 28BYJ-48.

  O arquivo 00_Parametros.scad mantem a interface de calibracao com rasgos
  longos usada pelo cupom inicial. Depois da validacao fisica do motor real,
  as pecas de producao usam uma fixacao rigida e totalmente determinada:

    - ressalto frontal de 9 mm = datum coaxial do eixo;
    - orelha esquerda = furo redondo M3;
    - orelha direita = furo redondo M3;
    - altura do eixo e distancia pinhao/cremalheira NAO mudam.

  Os dois furos usam 3,5 mm de diametro nominal para passagem de parafuso M3.
  A posicao final e definida pelo boss central + padrao de 35 mm ja validado
  fisicamente no cupom 99D.
*/

include <00_Parametros.scad>;

module motor_28byj48_mount_final_bridge_local(
  depth=motor_mount_pad_depth,
  pad_r=motor_mount_pad_r
) {
  // Ponte estrutural continua entre os dois apoios circulares. Nao existe
  // mais faixa de regulagem: a geometria final usa os centros validados.
  hull()
    for (sx=[-1,1])
      translate([sx*motor_mount_spacing/2,-motor_mount_line_offset,0])
        cylinder(r=pad_r,h=depth);
}

module motor_28byj48_mount_final_fasteners_local(
  depth=8.0,
  screw_r=motor_mount_screw_clearance_r
) {
  // Dois furos redondos M3. O ressalto central continua sendo o datum coaxial;
  // os parafusos apenas prendem a flange no padrao final ja validado.
  for (sx=[-1,1])
    translate([sx*motor_mount_spacing/2,-motor_mount_line_offset,-EPS])
      cylinder(r=screw_r,h=depth+2*EPS);
}
