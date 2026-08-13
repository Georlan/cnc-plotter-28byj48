import subprocess, os

CNC_DIR = '/home/testuser/Downloads/CNC'
ARTIFACT_DIR = '/home/testuser/.gemini/antigravity/brain/f0cc1cb4-f136-4c12-be8a-8a2e0be1299b'

views = [
    # 1. Close Transmissão X Exclusivo
    {
        'id': 'close_transmissao_x',
        'file': 'CNC_Plotter_Full_Assembly.scad',
        'args': ['-D', 'pos_x=86.0', '-D', 'pos_y=69.0', '--render', '--camera=86,22,25,86,25,17.5', '--autocenter', '--viewall']
    },
    # 2. Close Transmissão Y Exclusivo
    {
        'id': 'close_transmissao_y',
        'file': 'CNC_Plotter_Full_Assembly.scad',
        'args': ['-D', 'pos_x=86.0', '-D', 'pos_y=69.0', '--render', '--camera=100,75,22,96,69,15', '--autocenter', '--viewall']
    },
    # 3. Close Transmissão Z Exclusivo
    {
        'id': 'close_transmissao_z',
        'file': 'CNC_Plotter_Full_Assembly.scad',
        'args': ['-D', 'pos_x=86.0', '-D', 'pos_y=69.0', '--render', '--camera=65,82,30,78,82,20', '--autocenter', '--viewall']
    },
    # 4. Isométrica Geral Corrigida com Cores de Debug
    {
        'id': 'isometrica_geral_corrigida',
        'file': 'CNC_Plotter_Full_Assembly.scad',
        'args': ['-D', 'pos_x=86.0', '-D', 'pos_y=69.0', '-D', 'pos_z=0.0', '--camera=230,190,150,85,70,25', '--autocenter', '--viewall']
    }
]

print("=== GERANDO RENDERS DE AUDITORIA E VALIDAÇÃO DA TRANSMISSÃO X, Y E Z ===")
for v in views:
    out_png = os.path.join(ARTIFACT_DIR, f"{v['id']}.png")
    scad_path = os.path.join(CNC_DIR, v['file'])
    cmd = ['openscad', '--imgsize=1024,768', '--colorscheme=Tomorrow Night', '-o', out_png] + v['args'] + [scad_path]
    print(f"Gerando {v['id']}...")
    res = subprocess.run(cmd, stdout=subprocess.PIPE, stderr=subprocess.PIPE, text=True)
    if res.returncode == 0:
        print(f" -> Sucesso: {v['id']}.png")
    else:
        print(f" -> Erro em {v['id']}: {res.stderr}")
