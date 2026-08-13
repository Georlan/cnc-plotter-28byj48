#!/usr/bin/env python3
"""
=============================================================================
validate_geometry.py - Validação Geométrica Completa da CNC Plotter
=============================================================================
Compila cada SCAD -> STL via OpenSCAD CLI, depois analisa:
  1. Warnings de código do OpenSCAD (unknown variable, undef, undefined operation)
  2. Componentes conectados (via adjacência de vértices dos triângulos)
  3. Bounding boxes (min/max em X, Y, Z)
  4. min Z das peças (deve ser >= 0 para orientação FDM)
=============================================================================
"""

import subprocess, os, struct, sys, re
from pathlib import Path

CNC_DIR = Path(__file__).resolve().parent

# Peças a compilar e suas expectativas de componentes
# expected = -1 indica arquivo de montagem/referência (não-imprimível isoladamente)
PIECES = [
    ('01_Base_Trilho_X.scad',            '01_Base_Trilho_X.stl',            1),
    ('01B_Trilho_X_Passivo.scad',        '01B_Trilho_X_Passivo.stl',        1),
    ('02_Carrinho_X.scad',               '02_Carrinho_X.stl',               2),
    ('02B_Sapata_X_Passiva_PETG.scad',   '02B_Sapata_X_Passiva_PETG.stl',   1),
    # Uma peca fisica; os seis vazios fechados aparecem como cascas internas
    # independentes no STL, portanto o contador topologico retorna 7.
    ('03_Trilho_Y.scad',                 '03_Trilho_Y.stl',                 7),
    ('04_Carrinho_Y.scad',               '04_Carrinho_Y.stl',               1),
    ('05_Modulo_Z_Caneta.scad',          '05_Modulo_Z_Caneta.stl',          2),
    ('06_Pinhoes.scad',                  '06_Pinhoes.stl',                  3),
    ('07_Batentes.scad',                 '07_Batentes.stl',                 6),
    ('08_Clips_Fixacao_Papel.scad',      '08_Clips_Fixacao_Papel.stl',      4),
    ('91_Teste_Engrenamento_FDM.scad',   '91_Teste_Engrenamento_FDM.stl',   2),
    ('92_Teste_Estrutural.scad',         '92_Teste_Estrutural.stl',         1),
    ('93_Teste_Plano_Caneta.scad',       '93_Teste_Plano_Caneta.stl',       1),
    ('94_Teste_Engrenamento_Dinamico.scad','94_Teste_Engrenamento_Dinamico.stl',1),
    ('95_Teste_Montagem_Completa.scad',  '95_Teste_Montagem_Completa.stl',  1),
    ('97_Diagnostico_Motores.scad',      '97_Diagnostico_Motores.stl',      1),
    ('98_Teste_Interferencias.scad',     '98_Teste_Interferencias.stl',     1),
    ('99_Teste_Tolerancias.scad',        '99_Teste_Tolerancias.stl',       10),
    ('90_Componentes_Referencia.scad',   '90_Componentes_Referencia.stl',  -1),
    ('CNC_Plotter_Full_Assembly.scad',   'CNC_Plotter_Full_Assembly.stl',  -1),
]

# O teste 95 combina dezenas de intersection() vazias. OpenSCAD 2021 pode
# emitir aviso de 2-manifold durante a avaliacao, mesmo quando o STL final e
# somente o cubo marcador valido. Warnings de codigo continuam proibidos.
ALLOW_MANIFOLD_WARNING = {'95_Teste_Montagem_Completa.scad'}

def compile_scad(scad_file, stl_file):
    """Compila SCAD -> STL, retorna (sucesso, warnings_list, stderr)."""
    scad_path = CNC_DIR / scad_file
    stl_path  = CNC_DIR / stl_file
    
    cmd = ['openscad', '-o', str(stl_path), str(scad_path)]
    result = subprocess.run(cmd, capture_output=True, text=True, timeout=240)
    
    stderr = result.stderr
    warnings = []
    for line in stderr.split('\n'):
        ll = line.lower()
        if any(kw in ll for kw in ['warning', 'unknown variable', 'undef', 'undefined operation']):
            warnings.append(line.strip())
    
    success = os.path.exists(stl_path) and os.path.getsize(stl_path) > 84
    return success, warnings, stderr

def parse_stl(filepath):
    """Parse ASCII or Binary STL file into list of triangles."""
    with open(filepath, 'rb') as f:
        data = f.read()
    
    if data.strip().startswith(b'solid'):
        try:
            text = data.decode('utf-8', errors='ignore')
            vertices = re.findall(r'vertex\s+([-+]?\d*\.?\d+(?:[eE][-+]?\d+)?)\s+([-+]?\d*\.?\d+(?:[eE][-+]?\d+)?)\s+([-+]?\d*\.?\d+(?:[eE][-+]?\d+)?)', text)
            triangles = []
            for i in range(0, len(vertices) - 2, 3):
                v1 = (round(float(vertices[i][0]), 3), round(float(vertices[i][1]), 3), round(float(vertices[i][2]), 3))
                v2 = (round(float(vertices[i+1][0]), 3), round(float(vertices[i+1][1]), 3), round(float(vertices[i+1][2]), 3))
                v3 = (round(float(vertices[i+2][0]), 3), round(float(vertices[i+2][1]), 3), round(float(vertices[i+2][2]), 3))
                triangles.append((v1, v2, v3))
            return triangles
        except Exception:
            pass

    triangles = []
    if len(data) >= 84:
        num_tri = struct.unpack('<I', data[80:84])[0]
        offset = 84
        for _ in range(num_tri):
            if offset + 50 > len(data):
                break
            vals = struct.unpack('<12fH', data[offset:offset+50])
            v1 = (round(vals[3], 3), round(vals[4], 3), round(vals[5], 3))
            v2 = (round(vals[6], 3), round(vals[7], 3), round(vals[8], 3))
            v3 = (round(vals[9], 3), round(vals[10], 3), round(vals[11], 3))
            triangles.append((v1, v2, v3))
            offset += 50
    return triangles

def count_connected_components(filepath):
    """Count connected components using Union-Find on shared vertices."""
    triangles = parse_stl(filepath)
    if not triangles:
        return 0, None, None
    
    parent = {}
    
    def find(x):
        while parent[x] != x:
            parent[x] = parent[parent[x]]
            x = parent[x]
        return x
    
    def union(a, b):
        ra, rb = find(a), find(b)
        if ra != rb:
            parent[ra] = rb
    
    for v1, v2, v3 in triangles:
        for v in (v1, v2, v3):
            if v not in parent:
                parent[v] = v
        union(v1, v2)
        union(v2, v3)
    
    roots = set(find(v) for v in parent)
    num_components = len(roots)
    
    all_verts = list(parent.keys())
    xs = [v[0] for v in all_verts]
    ys = [v[1] for v in all_verts]
    zs = [v[2] for v in all_verts]
    
    bbox_min = (min(xs), min(ys), min(zs))
    bbox_max = (max(xs), max(ys), max(zs))
    
    return num_components, bbox_min, bbox_max

def main():
    results = []
    all_pass = True
    
    print("=" * 80)
    print("VALIDAÇÃO GEOMÉTRICA COMPLETA — CNC PLOTTER LOW-COST")
    print("=" * 80)
    
    for scad, stl, expected in PIECES:
        print(f"\n--- Compilando: {scad} ---")
        success, warnings, stderr = compile_scad(scad, stl)
        
        if not success:
            print(f"  ✗ FALHA na compilação!")
            print(f"  stderr: {stderr[:500]}")
            results.append((scad, stl, False, -1, None, None, warnings, expected))
            all_pass = False
            continue
        
        stl_path = CNC_DIR / stl
        num_comp, bbox_min, bbox_max = count_connected_components(stl_path)
        
        # Filtra apenas warnings graves de código (undef, unknown variable, undefined operation)
        code_warnings = [
            w for w in warnings 
            if any(kw in w.lower() for kw in ['unknown variable', 'undef', 'undefined operation'])
        ]
        
        # Para peças imprimíveis, exige 0 warnings totais (exceto deprecated)
        if expected != -1 and scad not in ALLOW_MANIFOLD_WARNING:
            bad_warnings = [w for w in warnings if 'deprecated' not in w.lower()]
        else:
            # Para montagem/referência, ignora apenas export-warning de 2-manifold de conjunto multi-peça
            bad_warnings = code_warnings
        
        has_bad_warnings = len(bad_warnings) > 0
        comp_ok = (expected == -1) or (num_comp == expected)
        z_ok = bbox_min is None or bbox_min[2] >= -0.1
        
        status = "✓ PASS" if (comp_ok and not has_bad_warnings and z_ok) else "✗ FAIL"
        if status == "✗ FAIL":
            all_pass = False
        
        size = None
        if bbox_min and bbox_max:
            size = (
                round(bbox_max[0] - bbox_min[0], 2),
                round(bbox_max[1] - bbox_min[1], 2),
                round(bbox_max[2] - bbox_min[2], 2)
            )
        
        print(f"  Componentes: {num_comp} (esperado: {expected if expected != -1 else 'N/A'})")
        if bbox_min:
            print(f"  BBox min: ({bbox_min[0]:.2f}, {bbox_min[1]:.2f}, {bbox_min[2]:.2f})")
            print(f"  BBox max: ({bbox_max[0]:.2f}, {bbox_max[1]:.2f}, {bbox_max[2]:.2f})")
            print(f"  Tamanho:  ({size[0]:.2f} x {size[1]:.2f} x {size[2]:.2f}) mm")
            print(f"  min Z:    {bbox_min[2]:.3f} mm")
        if bad_warnings:
            print(f"  ⚠ Warnings graves: {len(bad_warnings)}")
            for w in bad_warnings[:5]:
                print(f"    {w}")
        print(f"  {status}")
        
        results.append((scad, stl, success, num_comp, bbox_min, bbox_max, bad_warnings, expected))
    
    # =========================================================================
    # TABELA RESUMO
    # =========================================================================
    print("\n" + "=" * 80)
    print("TABELA RESUMO")
    print("=" * 80)
    print(f"{'ARQUIVO':<35} {'COMP':>5} {'ESPER':>5} {'WARNS':>5} {'STATUS':>8}")
    print("-" * 80)
    for scad, stl, success, nc, bmin, bmax, warns, exp in results:
        comp_str = str(nc) if nc >= 0 else "ERR"
        exp_str = str(exp) if exp >= 0 else "N/A"
        w_str = str(len(warns))
        comp_ok = (exp == -1) or (nc == exp)
        z_ok = bmin is None or bmin[2] >= -0.1
        status = "PASS" if (success and comp_ok and len(warns) == 0 and z_ok) else "FAIL"
        print(f"  {stl:<33} {comp_str:>5} {exp_str:>5} {w_str:>5} {status:>8}")
    
    print(f"\n{'RESULTADO GLOBAL':>40}: {'✓ TODOS PASSARAM' if all_pass else '✗ HÁ FALHAS'}")
    
    return 0 if all_pass else 1

if __name__ == '__main__':
    sys.exit(main())
