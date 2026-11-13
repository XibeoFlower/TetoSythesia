#!/bin/sh
# Build goi .deb cho Linux (Debian/Ubuntu/Mint...). Chay tu thu muc goc TetoSynthesia/:  sh build-deb.sh
set -e
VER=1.3.0
ROOT="$(cd "$(dirname "$0")" && pwd)"
PKG="$ROOT/build/tetosynthesia_${VER}_all"
rm -rf "$ROOT/build"
mkdir -p "$PKG/DEBIAN" "$PKG/opt/tetosynthesia/assets" "$PKG/usr/bin" "$PKG/usr/share/applications"
cp "$ROOT/TetoSynthesia.html" "$ROOT/TetoSynthesia.sh" "$ROOT/logo.png" "$ROOT/README-VI.md" "$PKG/opt/tetosynthesia/"
cp "$ROOT"/assets/* "$PKG/opt/tetosynthesia/assets/"
chmod 755 "$PKG/opt/tetosynthesia/TetoSynthesia.sh"
for s in 16 32 48 64 128 256 512; do
  mkdir -p "$PKG/usr/share/icons/hicolor/${s}x${s}/apps"
  cp "$ROOT/assets/icon-$s.png" "$PKG/usr/share/icons/hicolor/${s}x${s}/apps/tetosynthesia.png"
done
printf '#!/bin/sh\nexec /opt/tetosynthesia/TetoSynthesia.sh "$@"\n' > "$PKG/usr/bin/tetosynthesia"
chmod 755 "$PKG/usr/bin/tetosynthesia"
cat > "$PKG/usr/share/applications/tetosynthesia.desktop" <<D
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
cat > "$PKG/DEBIAN/control" <<C
Package: tetosynthesia
Version: $VER
Section: sound
Priority: optional
Architecture: all
Recommends: chromium | chromium-browser | google-chrome-stable
Maintainer: TetoSynthesia <noreply@example.com>
Description: TetoSynthesia - Black MIDI Player
 Monochrome Black MIDI player with 3D piano, 88/61 keys and computer-keyboard play.
C
dpkg-deb --build --root-owner-group "$PKG" "$ROOT/tetosynthesia_${VER}_all.deb"
echo "OK: $ROOT/tetosynthesia_${VER}_all.deb"
