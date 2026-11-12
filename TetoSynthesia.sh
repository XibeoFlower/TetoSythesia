#!/bin/sh
# TetoSynthesia v1.2.0 - Black MIDI Player
DIR="$(cd "$(dirname "$0")" && pwd)"
for b in xdg-open gio open; do
  command -v "$b" >/dev/null 2>&1 && exec "$b" "$DIR/TetoSynthesia.html"
done
echo "Khong tim thay trinh duyet - hay mo TetoSynthesia.html bang Chrome/Chromium."
