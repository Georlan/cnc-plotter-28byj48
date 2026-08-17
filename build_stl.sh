#!/bin/bash
# =============================================================================
# build_stl.sh - Compilação em lote das peças e cupons imprimíveis OpenSCAD
# =============================================================================

set -euo pipefail

SRC_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
OUT_DIR="${SRC_DIR}"

echo "======================================================="
echo " Compilação OpenSCAD -> STL"
echo " Diretorio: ${SRC_DIR}"
echo "======================================================="

# Fontes que geram peças/cupons físicos imprimíveis.
# Arquivos 90/92-98 são referências/validações e são cobertos por
# validate_geometry.py, não pelo lote de fabricação.
SCAD_FILES=(
  "01_Base_Trilho_X.scad"
  "01B_Trilho_X_Passivo.scad"
  "02_Carrinho_X.scad"
  "02B_Sapata_X_Passiva_PETG.scad"
  "03_Trilho_Y.scad"
  "04_Carrinho_Y.scad"
  "05_Modulo_Z_Caneta.scad"
  "06_Pinhoes.scad"
  "07_Batentes.scad"
  "08_Clips_Fixacao_Papel.scad"
  "91_Teste_Engrenamento_FDM.scad"
  "99_Teste_Tolerancias.scad"
  "99_Teste_Eixo_D.scad"
  "99_Teste_Folga_Pinhao_FDM.scad"
  "99B_Teste_Portaferramenta_FDM.scad"
  "placa_testes_completa.scad"
)

if ! command -v openscad >/dev/null 2>&1; then
  echo "Erro: OpenSCAD CLI nao encontrado no PATH."
  exit 2
fi

TOTAL=${#SCAD_FILES[@]}
COUNT=0
PASSED=0
FAILED=0

for file in "${SCAD_FILES[@]}"; do
  COUNT=$((COUNT + 1))
  stl_file="${file%.scad}.stl"
  log_file="$(mktemp)"

  if [ -f "${SRC_DIR}/${file}" ]; then
    echo -n "[$COUNT/$TOTAL] ${file} -> ${stl_file} ... "

    if openscad -o "${OUT_DIR}/${stl_file}" "${SRC_DIR}/${file}" >"${log_file}" 2>&1; then
      echo "OK"
      PASSED=$((PASSED + 1))
    else
      echo "ERRO"
      cat "${log_file}"
      FAILED=$((FAILED + 1))
    fi
  else
    echo "[$COUNT/$TOTAL] Arquivo nao encontrado: ${file}"
    FAILED=$((FAILED + 1))
  fi

  rm -f "${log_file}"
done

echo "======================================================="
echo " Total: ${TOTAL} | Sucesso: ${PASSED} | Erros: ${FAILED}"
echo "======================================================="

if [ "${FAILED}" -eq 0 ]; then
  exit 0
fi
exit 1
