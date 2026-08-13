#!/bin/bash
# =============================================================================
# build_stl.sh - Script de Compilação Automática em Lote (.scad -> .stl)
# =============================================================================
# Converte todos os arquivos de peças 3D .scad da pasta atual para .stl
# usando a linha de comando do OpenSCAD (openscad -o ...).
# =============================================================================

set -e

SRC_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
OUT_DIR="${SRC_DIR}"

echo "======================================================="
echo " Iniciando Compilação Automática em Lote com OpenSCAD  "
echo " Diretorio: ${SRC_DIR}"
echo "======================================================="

# Lista de peças 3D com geometria imprimível real
SCAD_FILES=(
  "01_Base_Trilho_X.scad"
  "02_Carrinho_X.scad"
  "03_Trilho_Y.scad"
  "04_Carrinho_Y.scad"
  "05_Modulo_Z_Caneta.scad"
  "06_Pinhoes.scad"
  "07_Batentes.scad"
  "08_Clips_Fixacao_Papel.scad"
  "95_Teste_Montagem_Completa.scad"
  "97_Diagnostico_Motores.scad"
  "98_Teste_Interferencias.scad"
  "99_Teste_Tolerancias.scad"
  "CNC_Plotter_Animated_Simulation.scad"
  "CNC_Plotter_Full_Assembly.scad"
)

TOTAL=${#SCAD_FILES[@]}
COUNT=0
PASSED=0
FAILED=0

for file in "${SCAD_FILES[@]}"; do
  COUNT=$((COUNT + 1))
  stl_file="${file%.scad}.stl"
  
  if [ -f "${SRC_DIR}/${file}" ]; then
    echo -n "[$COUNT/$TOTAL] Compilando: ${file} -> ${stl_file} ... "
    
    if openscad -o "${OUT_DIR}/${stl_file}" "${SRC_DIR}/${file}" > /dev/null 2>&1; then
      echo "✓ Concluído"
      PASSED=$((PASSED + 1))
    else
      echo "✗ Erro na compilação!"
      FAILED=$((FAILED + 1))
    fi
  else
    echo "[$COUNT/$TOTAL] Arquivo não encontrado: ${file} (Ignorado)"
  fi
done

echo "======================================================="
echo " Resumo da Compilação: "
echo "  Total: ${TOTAL} | Sucesso: ${PASSED} | Erros: ${FAILED}"
echo "======================================================="

if [ $FAILED -eq 0 ]; then
  exit 0
else
  exit 1
fi
