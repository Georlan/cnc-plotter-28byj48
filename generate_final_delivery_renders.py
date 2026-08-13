import subprocess, os

CNC_DIR = '/home/testuser/Downloads/CNC'
ARTIFACT_DIR = '/home/testuser/.gemini/antigravity/brain/f0cc1cb4-f136-4c12-be8a-8a2e0be1299b'

renders = [
    # 1. Base X — isométrica
    {
        'file': '01_Base_Trilho_X.scad',
        'out': os.path.join(ARTIFACT_DIR, '01_base_x_isometric.png'),
        'camera': '100,15,7.25,55,0,225,350',
    },
    # 2. Base X — seção transversal ortográfica
    {
        'file': '01_Base_Trilho_X.scad',
        'out': os.path.join(ARTIFACT_DIR, '02_base_x_cross_section.png'),
        'camera': '100,15,7.25,90,0,0,120',
        'projection': 'o',
    },
    # 3. Base X — vista inferior
    {
        'file': '01_Base_Trilho_X.scad',
        'out': os.path.join(ARTIFACT_DIR, '03_base_x_bottom_view.png'),
        'camera': '100,15,7.25,180,0,0,320',
    },
    # 4. Carrinho X — isométrica
    {
        'file': '02_Carrinho_X.scad',
        'out': os.path.join(ARTIFACT_DIR, '04_carrinho_x_isometric.png'),
        'camera': '14,16.2,6,55,0,45,100',
    },
    # 5. Dovetail macho + fêmea em corte (via Teste de Tolerâncias)
    {
        'file': '99_Teste_Tolerancias.scad',
        'out': os.path.join(ARTIFACT_DIR, '05_dovetail_cross_section.png'),
        'camera': '10,10,3.5,90,0,0,60',
        'projection': 'o',
    },
    # 6. Rack + pinhão X em close
    {
        'file': 'CNC_Plotter_Full_Assembly.scad',
        'out': os.path.join(ARTIFACT_DIR, '06_close_transmissao_x.png'),
        'camera': '94,25,17.5,65,0,135,60',
    },
    # 7. Trilho Y — seção transversal
    {
        'file': '03_Trilho_Y.scad',
        'out': os.path.join(ARTIFACT_DIR, '07_trilho_y_cross_section.png'),
        'camera': '12,98,7.25,0,0,0,100',
        'projection': 'o',
    },
    # 8. Rack + pinhão Y em close
    {
        'file': 'CNC_Plotter_Full_Assembly.scad',
        'out': os.path.join(ARTIFACT_DIR, '08_close_transmissao_y.png'),
        'camera': '100,72,25,65,0,45,70',
    },
    # 9. Rack + pinhão Z em close
    {
        'file': 'CNC_Plotter_Full_Assembly.scad',
        'out': os.path.join(ARTIFACT_DIR, '09_close_transmissao_z.png'),
        'camera': '90,72,35,60,0,210,60',
    },
    # 10. Assembly geral
    {
        'file': 'CNC_Plotter_Full_Assembly.scad',
        'out': os.path.join(ARTIFACT_DIR, '10_assembly_geral.png'),
        'camera': '100,100,30,55,0,215,400',
    },
]

print("Iniciando renderização de 10 imagens de entrega...")
for r in renders:
    scad_path = os.path.join(CNC_DIR, r['file'])
    cmd = [
        'openscad',
        '-o', r['out'],
        '--imgsize=1024,768',
        f"--camera={r['camera']}"
    ]
    if r.get('projection') == 'o':
        cmd.append('--projection=o')
    cmd.append(scad_path)
    
    print(f"Renderizando {os.path.basename(r['out'])}...")
    res = subprocess.run(cmd, capture_output=True, text=True)
    if res.returncode == 0:
        print(f"  ✓ Ok!")
    else:
        print(f"  ✗ Erro: {res.stderr}")

print("Concluído!")
