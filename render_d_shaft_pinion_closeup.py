import subprocess, os

CNC_DIR = '/home/testuser/Downloads/CNC'
ARTIFACT_DIR = '/home/testuser/.gemini/antigravity/brain/f0cc1cb4-f136-4c12-be8a-8a2e0be1299b'
out_png = os.path.join(ARTIFACT_DIR, 'close_eixo_d_pinhao.png')

# Criar arquivo SCAD temporário de visualização do Eixo D + Pinhão D-Hole
scad_temp = os.path.join(CNC_DIR, 'temp_d_shaft_view.scad')
with open(scad_temp, 'w') as f:
    f.write('''
include <00_Parametros.scad>;
use <06_Pinhoes.scad>;
use <90_Componentes_Referencia.scad>;

// Visualização em corte da montagem do Eixo D no Pinhão D-Hole
translate([0, 0, 0])
  rotate([-90, 0, 0])
    motor_28byj48_reference();

color([1.0, 0.5, 0.0, 0.95])
  translate([0, 22.0, 0])
    rotate([-90, 0, 0])
      pinion_gear(teeth=10, pitch=4.0, thickness=7.0);
''')

cmd = ['openscad', '--imgsize=1024,768', '--colorscheme=Tomorrow Night', '--render', '--camera=0,22,5,0,22,0', '--autocenter', '--viewall', '-o', out_png, scad_temp]
res = subprocess.run(cmd, stdout=subprocess.PIPE, stderr=subprocess.PIPE, text=True)

if os.path.exists(scad_temp):
    os.remove(scad_temp)

if res.returncode == 0:
    print(" -> Sucesso: close_eixo_d_pinhao.png gerado!")
else:
    print(f" -> Erro ao gerado close: {res.stderr}")
