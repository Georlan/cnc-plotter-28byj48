#!/usr/bin/env bash
set -euo pipefail

SRC_DIR="bambulab_3mf"
OUT_DIR="bambu_project_3mf"
APPIMAGE="/tmp/BambuStudio.AppImage"
APPDIR="/tmp/bambu-app"
BAMBU_VERSION="v02.08.02.61"
BAMBU_URL="https://github.com/bambulab/BambuStudio/releases/download/${BAMBU_VERSION}/BambuStudio_ubuntu24.04-v02.08.02.61-20260820225108.AppImage"
BAMBU_SHA256="d501b103fac5424513ec0e8d6bc145fb30719de2c7d94d7320d723740c81a7fd"

mkdir -p "$OUT_DIR"
rm -rf "$APPDIR"

if [[ ! -f "$APPIMAGE" ]]; then
  curl -L --fail --retry 3 -o "$APPIMAGE" "$BAMBU_URL"
fi
echo "$BAMBU_SHA256  $APPIMAGE" | sha256sum -c -
chmod +x "$APPIMAGE"
(
  cd /tmp
  "$APPIMAGE" --appimage-extract >/dev/null
)
mv /tmp/squashfs-root "$APPDIR"

BAMBU_BIN="$APPDIR/AppRun"
if [[ ! -x "$BAMBU_BIN" ]]; then
  echo "Bambu Studio AppRun not found" >&2
  exit 1
fi

PROFILE_ROOT="$APPDIR"
find_profile() {
  local kind="$1"
  local pattern="$2"
  find "$PROFILE_ROOT" -type f -path "*/profiles/BBL/${kind}/*.json" -iname "$pattern" | grep -vi 'mini' | head -n1
}

MACHINE=$(find_profile machine '*A1*0.4*nozzle*.json')
PROCESS=$(find_profile process '*0.16mm*Optimal*A1*.json')
PLA=$(find_profile filament '*Generic*PLA*A1*.json')
PETG=$(find_profile filament '*Generic*PETG*A1*.json')

# Fallbacks for profile naming changes across Bambu Studio releases.
[[ -n "${MACHINE:-}" ]] || MACHINE=$(find "$PROFILE_ROOT" -type f -path '*/profiles/BBL/machine/*.json' -iname '*A1*0.4*.json' | grep -vi mini | head -n1)
[[ -n "${PROCESS:-}" ]] || PROCESS=$(find "$PROFILE_ROOT" -type f -path '*/profiles/BBL/process/*.json' -iname '*0.16mm*Optimal*.json' | head -n1)
[[ -n "${PLA:-}" ]] || PLA=$(find "$PROFILE_ROOT" -type f -path '*/profiles/BBL/filament/*.json' -iname '*Generic*PLA*.json' | head -n1)
[[ -n "${PETG:-}" ]] || PETG=$(find "$PROFILE_ROOT" -type f -path '*/profiles/BBL/filament/*.json' -iname '*Generic*PETG*.json' | head -n1)

for f in "$MACHINE" "$PROCESS" "$PLA" "$PETG"; do
  test -s "$f" || { echo "Required Bambu profile not found: $f" >&2; exit 1; }
done

echo "Machine:  $MACHINE"
echo "Process:  $PROCESS"
echo "PLA:      $PLA"
echo "PETG:     $PETG"

is_petg() {
  case "$1" in
    *02B_Sapata_X_Passiva_PETG*|*05_Modulo_Z_Caneta*|*06_Pinhoes*|*07_Batentes*) return 0 ;;
    *) return 1 ;;
  esac
}

export_one() {
  local input="$1"
  local base
  local filament
  base=$(basename "$input")
  filament="$PLA"
  if is_petg "$base"; then
    filament="$PETG"
  fi

  echo "[Bambu project] $input -> $OUT_DIR/$base"
  rm -f "$OUT_DIR/$base"

  xvfb-run -a "$BAMBU_BIN" \
    --debug 2 \
    --load-settings "$MACHINE;$PROCESS" \
    --load-filaments "$filament" \
    --arrange 1 \
    --outputdir "$OUT_DIR" \
    --export-3mf "$base" \
    "$input"

  test -s "$OUT_DIR/$base"
  unzip -tqq "$OUT_DIR/$base"
  unzip -l "$OUT_DIR/$base" | grep -q '3D/3dmodel.model'
  unzip -l "$OUT_DIR/$base" | grep -q 'Metadata/project_settings.config'
  unzip -l "$OUT_DIR/$base" | grep -q 'Metadata/model_settings.config'

  # Re-open through Bambu Studio CLI; failure here means the project is not safe to publish.
  xvfb-run -a "$BAMBU_BIN" --debug 2 --info "$OUT_DIR/$base" >/tmp/bambu-info.log 2>&1 || {
    cat /tmp/bambu-info.log >&2
    exit 1
  }
}

for input in \
  "$SRC_DIR/01_Base_Trilho_X.3mf" \
  "$SRC_DIR/01B_Trilho_X_Passivo.3mf" \
  "$SRC_DIR/02_Carrinho_X.3mf" \
  "$SRC_DIR/02B_Sapata_X_Passiva_PETG.3mf" \
  "$SRC_DIR/03_Trilho_Y.3mf" \
  "$SRC_DIR/04_Carrinho_Y.3mf" \
  "$SRC_DIR/05_Modulo_Z_Caneta.3mf" \
  "$SRC_DIR/06_Pinhoes.3mf" \
  "$SRC_DIR/07_Batentes.3mf" \
  "$SRC_DIR/08_Clips_Fixacao_Papel.3mf"; do
  test -s "$input"
  export_one "$input"
done

echo
echo "Native Bambu Studio project 3MF files:"
find "$OUT_DIR" -maxdepth 1 -type f -name '*.3mf' -printf '%p\t%k KiB\n' | sort
