#!/usr/bin/env bash
# Usage: ./tools/prepare-sketch.sh hold /path/to/HidKeyboard
# Or:    ./tools/prepare-sketch.sh tap  /path/to/HidKeyboard
set -euo pipefail
MODE="${1:-hold}"
EXAMPLE="${2:-}"
if [[ "$MODE" != "hold" && "$MODE" != "tap" ]]; then echo "Mode must be hold or tap" >&2; exit 2; fi
if [[ -z "$EXAMPLE" ]]; then echo "Supply path to installed CH55xDuino HidKeyboard example" >&2; exit 2; fi
ROOT="$(cd "$(dirname "$0")/.." && pwd)"
if [[ ! -f "$EXAMPLE/src/userUsbHidKeyboard/USBconstant.c" ]]; then echo "Invalid example path" >&2; exit 2; fi
DEST="$ROOT/build/$MODE/Morse_Code"
if [[ -e "$DEST" ]]; then echo "Refusing to overwrite $DEST" >&2; exit 1; fi
mkdir -p "$DEST"
cp -R "$EXAMPLE/src" "$DEST/src"
cp "$ROOT/usb-overrides/userUsbHidKeyboard/"* "$DEST/src/userUsbHidKeyboard/"
cp "$ROOT/firmware/$MODE/Morse_Code.ino" "$DEST/Morse_Code.ino"
echo "Prepared $DEST"
