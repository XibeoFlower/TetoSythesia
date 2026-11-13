#!/bin/sh
# Build TetoSynthesia-1.3.0-x86_64.AppImage (chay duoc tren hau het distro Linux).  Chay:  sh build-appimage.sh
set -e
VER=1.3.0
ROOT="$(cd "$(dirname "$0")" && pwd)"
APPDIR="$ROOT/build/TetoSynthesia.AppDir"
TOOL="$ROOT/build/appimagetool.AppImage"
rm -rf "$ROOT/build"; mkdir -p "$APPDIR/usr/share/tetosynthesia/assets" "$ROOT/build"

cp "$ROOT/TetoSynthesia.html" "$ROOT/TetoSynthesia.sh" "$ROOT/logo.png" "$ROOT/README-VI.md" "$ROOT/LICENSE.txt" "$APPDIR/usr/share/tetosynthesia/"
cp "$ROOT"/assets/* "$APPDIR/usr/share/tetosynthesia/assets/"
chmod 755 "$APPDIR/usr/share/tetosynthesia/TetoSynthesia.sh"
cp "$ROOT/assets/icon-256.png" "$APPDIR/tetosynthesia.png"
cp "$ROOT/assets/icon-256.png" "$APPDIR/.DirIcon"

cat > "$APPDIR/tetosynthesia.desktop" <<D
[Desktop Entry]
Type=Application
Name=TetoSynthesia
GenericName=Black MIDI Player
Comment=Black MIDI Player - piano 3D, 88/61 keys
Exec=tetosynthesia
Icon=tetosynthesia
Terminal=false
Categories=AudioVideo;Audio;Midi;Music;
StartupWMClass=TetoSynthesia
D

cat > "$APPDIR/AppRun" <<'A'
#!/bin/sh
HERE="$(dirname "$(readlink -f "$0")")"
exec "$HERE/usr/share/tetosynthesia/TetoSynthesia.sh" "$@"
A
chmod 755 "$APPDIR/AppRun"

[ -n "$APPDIR_ONLY" ] && { echo "AppDir: $APPDIR"; exit 0; }

echo "Tai appimagetool..."
curl -fL -o "$TOOL" https://github.com/AppImage/appimagetool/releases/download/continuous/appimagetool-x86_64.AppImage
chmod +x "$TOOL"
ARCH=x86_64 "$TOOL" --appimage-extract-and-run "$APPDIR" "$ROOT/TetoSynthesia-$VER-x86_64.AppImage"
ls -la "$ROOT"/TetoSynthesia-*.AppImage
