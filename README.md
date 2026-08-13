# CNC Plotter 28BYJ-48 — 3D Printed Low-Cost Plotter

High-precision, 3D printable 3-axis CNC Plotter designed in **OpenSCAD** and calibrated specifically for the **Bambu Lab A1** (and similar high-accuracy FDM 3D printers).

---

## 📐 Key Specifications & Tolerances

- **Build Volume / Travel:** $164 \text{ mm} \times 138 \text{ mm} \times 6 \text{ mm}$ (A5 Paper compatible).
- **Motors:** 3x **28BYJ-48 5V Stepper Motors** with D-shaft output ($5.0 \text{ mm}$ shaft diameter, $3.0 \text{ mm}$ flat).
- **Linear Motion:** Integrated **Dovetail (Rabo de Andorinha)** rails and sliders.
- **Drive System:** Rack and Pinion ($10 \text{T}$ Mod 1.5 equivalent pinions, $4.0 \text{ mm}$ tooth pitch).
- **Bambu Lab A1 Calibrated Clearances:**
  - `slide_clearance` = $0.18 \text{ mm}$ per side ($0.36 \text{ mm}$ total channel clearance for zero-wobble smooth motion).
  - `pressfit_clearance` = $0.10 \text{ mm}$.
  - `m4_hole_pass` = $4.30 \text{ mm}$.
  - `m3_hole_pass` = $3.20 \text{ mm}$.

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
├── CNC_Plotter_Full_Assembly.scad    # Complete 3D Assembly File
├── 01_Base_Trilho_X.stl              # Pre-compiled STL for Base X
├── 02_Carrinho_X.stl              # Pre-compiled STL for Carriage X
├── 03_Trilho_Y.stl              # Pre-compiled STL for Rail Y
├── 04_Carrinho_Y.stl              # Pre-compiled STL for Carriage Y
├── 05_Modulo_Z_Caneta.stl       # Pre-compiled STL for Z Module
├── 06_Pinhoes.stl               # Pre-compiled STL for Pinions
└── testecnc/                         # Zoo KCL 2.0 modular implementation
```

---

## 🖨️ 3D Printing Instructions (Bambu Lab A1)

1. **Slicer Settings:**
   - **Layer Height:** $0.20 \text{ mm}$ Standard (or $0.16 \text{ mm}$ Optimal).
   - **Wall Loops (Perimeters):** $3$ to $4$ walls for strength.
   - **Infill:** $15\% - 20\%$ Gyroid or Grid.
   - **Supports:** **DISABLED** (all parts are engineered to print support-free flat on the PEI bed).
   - **Material:** PLA / PETG.

---

## ⚙️ Assembly Quick Guide

1. **Axis X:** Slide `02_Carrinho_X` onto `01_Base_Trilho_X`. Mount 28BYJ-48 motor with M3 screws and attach 10T pinion `06_Pinhoes`.
2. **Axis Y:** Attach `03_Trilho_Y` perpendicular onto `02_Carrinho_X`. Slide `04_Carrinho_Y` onto `03_Trilho_Y`.
3. **Axis Z:** Mount `05_Modulo_Z_Caneta` onto `04_Carrinho_Y`. Insert spring ($8.5\text{mm}$ OD) and pen plunger.

---

## 📄 License
Open-Source Hardware — Free to use, modify, and distribute for personal and educational projects.
