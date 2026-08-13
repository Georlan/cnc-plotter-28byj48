# CNC Plotter 28BYJ-48 — 3D Printed Low-Cost Plotter

Plotter CNC educacional de baixo custo, modelada parametricamente em **OpenSCAD** para fabricacao FDM na **Bambu Lab A1**.

---

## 📐 Key Specifications & Tolerances

- **Curso nominal:** $164 \text{ mm} \times 138 \text{ mm} \times 6 \text{ mm}$.
- **Papel:** suporte para A5. O curso de 164 x 138 mm **nao cobre toda a folha A5**; posicione a area do desenho dentro desses limites.
- **Motors:** 3x **28BYJ-48 5V Stepper Motors** with D-shaft output ($5.0 \text{ mm}$ shaft diameter, $3.0 \text{ mm}$ flat).
- **Linear Motion:** Integrated **Dovetail (Rabo de Andorinha)** rails and sliders.
- **Transmissao:** cremalheira e pinhao de 10 dentes, passo circular de 4,0 mm (modulo geometrico aproximado $m=p/\pi=1.27$, nao modulo 1.5).
- **Bambu Lab A1 Calibrated Clearances:**
  - `slide_clearance_xy` = $0.25 \text{ mm}$ por lado no modelo atual.
  - `slide_clearance_z` = $0.20 \text{ mm}$ por lado.
  - Antes dos trilhos completos, imprima `99_Teste_Tolerancias.scad` e selecione a menor folga que deslize sem travar.

---

## 📁 Repository Structure

```text
CNC/
├── 00_Parametros.scad                # Global parameters & shared geometric modules
├── 01_Base_Trilho_X.scad             # Base Rail X (200mm long)
├── 02_Carrinho_X.scad                # Carriage X (Slides on Base Rail X, holds Motor X)
├── 03_Trilho_Y.scad                  # Rail Y (196mm long, mounts on Carriage X)
├── 04_Carrinho_Y.scad                # Carriage Y (Slides on Rail Y, holds Motor Y)
├── 05_Modulo_Z_Caneta.scad           # Pen Z-Axis Module with spring compliance plunger
├── 06_Pinhoes.scad                   # 10-Tooth D-Shaft Pinion Gears
├── 07_Batentes.scad                  # Mechanical Endstops & Rail Stops
├── 08_Clips_Fixacao_Papel.scad       # A5 Bed Paper Clips
├── 96_Validacao_Curso.scad            # Montagem em centro/cantos via -D
├── 97_Diagnostico_Motores.scad        # Teste CSG dos envelopes dos motores
├── 98_Teste_Interferencias.scad       # Teste automatizado pinhoes/carro Z
├── 99_Teste_Tolerancias.scad         # Cupom de folgas das guias
├── CNC_Plotter_Full_Assembly.scad    # Complete 3D Assembly File
└── testecnc/                         # Zoo KCL 2.0 modular implementation
```

Os arquivos `.stl` da raiz sao artefatos gerados e nao ficam versionados. Gere a versao atual com:

```bash
./build_stl.sh
```

Isso evita que um STL antigo seja confundido com a geometria atual dos arquivos `.scad`.

---

## 🖨️ 3D Printing Instructions (Bambu Lab A1)

1. **Slicer Settings:**
   - **Layer Height:** 0,24 mm para entrega rapida; 0,20 mm para a versao final.
   - **Wall Loops:** 3 nos trilhos/carrinhos; 5 nos pinhoes.
   - **Infill:** 10-12% Grid nos trilhos; 15% nos carrinhos; 100% nos pinhoes pequenos.
   - **Top/Bottom:** 4 camadas.
   - **Brim:** 5 mm nos trilhos longos.
   - **Supports:** **DISABLED** (all parts are engineered to print support-free flat on the PEI bed).
   - **Material:** PLA / PETG.

---

## ⚙️ Assembly Quick Guide

1. **Axis X:** Slide `02_Carrinho_X` onto `01_Base_Trilho_X`. Mount 28BYJ-48 motor with M3 screws and attach 10T pinion `06_Pinhoes`.
2. **Axis Y:** Attach `03_Trilho_Y` perpendicular onto `02_Carrinho_X`. Slide `04_Carrinho_Y` onto `03_Trilho_Y`.
3. **Eixo Z:** insira o carro retangular de `05_Modulo_Z_Caneta` na guia do `04_Carrinho_Y`. Passe a caneta pelo carro, fixe o colar com M3 e coloque uma mola ao redor da caneta entre colar e ponte superior.

### Mola recomendada para o Z

- Diametro interno minimo: 10,8 mm para uma caneta de 10 mm.
- Diametro externo nominal: 13 mm.
- Comprimento livre: 14 mm.
- Rigidez alvo: 0,15 a 0,25 N/mm (modelo usa 0,20 N/mm como referencia).
- Pre-carga: 1 mm; curso complacente maximo: 3 mm.

Essa faixa produz aproximadamente 0,2 N no contato inicial e 0,8 N no fim do curso. Valide com a caneta e o papel reais antes de executar desenhos longos.

## Ordem de fabricacao recomendada

1. Imprima o cupom `99_Teste_Tolerancias.scad`.
2. Imprima um pinhao e um trecho curto de cremalheira para conferir engrenamento.
3. Imprima os dois carrinhos e o modulo Z; monte os tres motores fora dos trilhos.
4. Somente depois imprima os trilhos X/Y completos.

`97_Diagnostico_Motores.scad` e `98_Teste_Interferencias.scad` devem exportar
somente seus cubos marcadores de 1 mm. Geometria adicional significa colisao.
O teste 97 percorre centro e extremos X/Y/Z e verifica corpos dos tres motores
contra trilhos, carrinhos, modulo Z e entre si.

Para inspecao visual repetivel, abra `96_Validacao_Curso.scad` ou compile com
`-D 'VALIDATION_POSITION=0'` ate `4`: `0` e o centro e `1..4` sao os quatro
cantos do curso.

---

## 📄 License
Open-Source Hardware — Free to use, modify, and distribute for personal and educational projects.
