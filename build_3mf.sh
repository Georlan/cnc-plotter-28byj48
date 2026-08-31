#!/usr/bin/env bash
set -euo pipefail

OUT="bambulab_3mf"
TEST_OUT="$OUT/testes"
mkdir -p "$OUT" "$TEST_OUT"

# Preserve only validation coupons that may carry manually tuned Bambu Studio
# settings. Production geometry must always be regenerated from the current
# OpenSCAD sources so stale 3MF meshes cannot survive CAD changes.
if [[ -f 91_Teste_Engrenamento_FDM.3mf ]]; then
  mv -f 91_Teste_Engrenamento_FDM.3mf "$TEST_OUT/91_Teste_Engrenamento_FDM.3mf"
fi
if [[ -f 99_Teste_Tolerancias.3mf ]]; then
  mv -f 99_Teste_Tolerancias.3mf "$TEST_OUT/99_Teste_Tolerancias.3mf"
fi

# Remove known obsolete/error Bambu artifact if present.
rm -f erro.3mf

build_3mf() {
  local src="$1"
  local dst="$2"
  echo "[3MF] $src -> $dst"
  openscad -o "$dst" "$src"
  test -s "$dst"
  unzip -tqq "$dst"
  unzip -l "$dst" | grep -q "3D/3dmodel.model"
}

# Main printable parts. Always regenerate production geometry from OpenSCAD.
build_3mf 01_Base_Trilho_X.scad "$OUT/01_Base_Trilho_X.3mf"
build_3mf 01B_Trilho_X_Passivo.scad "$OUT/01B_Trilho_X_Passivo.3mf"
build_3mf 02_Carrinho_X.scad "$OUT/02_Carrinho_X.3mf"
build_3mf 02B_Sapata_X_Passiva_PETG.scad "$OUT/02B_Sapata_X_Passiva_PETG.3mf"
build_3mf 03_Trilho_Y.scad "$OUT/03_Trilho_Y.3mf"
build_3mf 04_Carrinho_Y.scad "$OUT/04_Carrinho_Y.3mf"
build_3mf 05_Modulo_Z_Caneta.scad "$OUT/05_Modulo_Z_Caneta.3mf"
build_3mf 06_Pinhoes.scad "$OUT/06_Pinhoes.3mf"
build_3mf 07_Batentes.scad "$OUT/07_Batentes.3mf"
build_3mf 08_Clips_Fixacao_Papel.scad "$OUT/08_Clips_Fixacao_Papel.3mf"

# Physical validation coupons useful in Bambu Studio.
if [[ ! -s "$TEST_OUT/91_Teste_Engrenamento_FDM.3mf" ]]; then
  build_3mf 91_Teste_Engrenamento_FDM.scad "$TEST_OUT/91_Teste_Engrenamento_FDM.3mf"
fi
if [[ ! -s "$TEST_OUT/99_Teste_Tolerancias.3mf" ]]; then
  build_3mf 99_Teste_Tolerancias.scad "$TEST_OUT/99_Teste_Tolerancias.3mf"
fi
build_3mf 99D_Teste_Fixacao_Motor_28BYJ48.scad "$TEST_OUT/99D_Teste_Fixacao_Motor_28BYJ48.3mf"
build_3mf 99_Teste_Folga_Pinhao_FDM.scad "$TEST_OUT/99_Teste_Folga_Pinhao_FDM.3mf"
build_3mf 99B_Teste_Portaferramenta_FDM.scad "$TEST_OUT/99B_Teste_Portaferramenta_FDM.3mf"
build_3mf 99_Teste_Eixo_D.scad "$TEST_OUT/99_Teste_Eixo_D.3mf"

echo
echo "Generated Bambu Lab 3MF files:"
find "$OUT" -type f -name '*.3mf' -printf '%p\t%k KiB\n' | sort
