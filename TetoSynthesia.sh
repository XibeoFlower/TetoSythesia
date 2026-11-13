#!/bin/sh
# TetoSynthesia v1.3.0 - mo o dang cua so app (Chrome/Chromium/Edge --app), neu khong co thi mo bang trinh duyet mac dinh
DIR="$(cd "$(dirname "$0")" && pwd)"
URL="file://$DIR/TetoSynthesia.html"
PROF="${XDG_DATA_HOME:-$HOME/.local/share}/TetoSynthesia/profile"
for b in google-chrome google-chrome-stable chromium chromium-browser microsoft-edge brave-browser; do
  if command -v "$b" >/dev/null 2>&1; then
    exec "$b" --app="$URL" --user-data-dir="$PROF" --class=TetoSynthesia --start-maximized
  fi
done
for b in xdg-open gio open; do
  command -v "$b" >/dev/null 2>&1 && exec "$b" "$DIR/TetoSynthesia.html"
done
echo "Khong tim thay trinh duyet - hay mo TetoSynthesia.html bang Chrome/Chromium."
