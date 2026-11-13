#!/bin/sh
# TetoSynthesia Setup (Linux) - cai vao ~/.local/share/TetoSynthesia, khong can root
# Tao icon (logo) trong menu ung dung + Desktop.   Go cai dat: ~/.local/share/TetoSynthesia/uninstall.sh
set -e
SRC="$(cd "$(dirname "$0")" && pwd)"
DATA="${XDG_DATA_HOME:-$HOME/.local/share}"
DEST="$DATA/TetoSynthesia"
APPS="$DATA/applications"
ICONS="$DATA/icons/hicolor"
VER="1.3.0"

say() { echo "[TetoSynthesia] $*"; }
if command -v zenity >/dev/null 2>&1 && [ -n "$DISPLAY$WAYLAND_DISPLAY" ] && [ -z "$TETO_NO_GUI" ]; then
  zenity --question --title="TetoSynthesia Setup" --window-icon="$SRC/assets/icon-128.png" \
    --icon="$SRC/assets/icon-128.png" --text="Cài đặt TetoSynthesia v$VER?\n\nInstall TetoSynthesia v$VER?" \
    --ok-label="Cài đặt / Install" --cancel-label="Huỷ / Cancel" 2>/dev/null || exit 0
fi
say "Cai dat vao $DEST"
mkdir -p "$DEST/assets" "$APPS"
for f in TetoSynthesia.html TetoSynthesia.sh logo.png README-VI.md LICENSE.txt; do cp -f "$SRC/$f" "$DEST/$f"; done
cp -f "$SRC"/assets/* "$DEST/assets/"
chmod +x "$DEST/TetoSynthesia.sh"

# icon (logo) cac kich co
for s in 16 32 48 64 128 256 512; do
  mkdir -p "$ICONS/${s}x${s}/apps"
  cp -f "$SRC/assets/icon-$s.png" "$ICONS/${s}x${s}/apps/tetosynthesia.png"
done

DESKTOP_FILE="[Desktop Entry]
Type=Application
Version=1.0
Name=TetoSynthesia
GenericName=Black MIDI Player
Comment=Black MIDI Player - piano 3D, 88/61 keys
Exec=\"$DEST/TetoSynthesia.sh\"
Icon=tetosynthesia
Terminal=false
Categories=AudioVideo;Audio;Midi;Music;
StartupWMClass=TetoSynthesia
"
printf '%s' "$DESKTOP_FILE" > "$APPS/tetosynthesia.desktop"
chmod +x "$APPS/tetosynthesia.desktop"

# icon ngoai Desktop
DESK="$(xdg-user-dir DESKTOP 2>/dev/null || true)"
[ -z "$DESK" ] && DESK="$HOME/Desktop"
if [ -d "$DESK" ]; then
  printf '%s' "$DESKTOP_FILE" > "$DESK/TetoSynthesia.desktop"
  chmod +x "$DESK/TetoSynthesia.desktop"
  command -v gio >/dev/null 2>&1 && gio set "$DESK/TetoSynthesia.desktop" metadata::trusted true 2>/dev/null || true
  say "Da tao icon Desktop: $DESK/TetoSynthesia.desktop"
fi

cat > "$DEST/uninstall.sh" <<UNI
#!/bin/sh
rm -f "$APPS/tetosynthesia.desktop" "$DESK/TetoSynthesia.desktop"
for s in 16 32 48 64 128 256 512; do rm -f "$ICONS/\${s}x\${s}/apps/tetosynthesia.png"; done
rm -rf "$DEST"
echo "TetoSynthesia da duoc go cai dat."
UNI
chmod +x "$DEST/uninstall.sh"

command -v update-desktop-database >/dev/null 2>&1 && update-desktop-database "$APPS" 2>/dev/null || true
command -v gtk-update-icon-cache >/dev/null 2>&1 && gtk-update-icon-cache -q -t "$ICONS" 2>/dev/null || true
say "Hoan tat! Mo TetoSynthesia tu menu ung dung hoac icon Desktop."
if command -v zenity >/dev/null 2>&1 && [ -n "$DISPLAY$WAYLAND_DISPLAY" ] && [ -z "$TETO_NO_GUI" ]; then
  zenity --info --title="TetoSynthesia Setup" --window-icon="$SRC/assets/icon-128.png" --icon="$SRC/assets/icon-128.png" \
    --text="Hoàn tất! / Done!\n\nMở TetoSynthesia từ menu ứng dụng hoặc icon Desktop." 2>/dev/null || true
fi
