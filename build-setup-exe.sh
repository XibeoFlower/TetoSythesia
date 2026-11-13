#!/bin/sh
# Build TetoSynthesia-Setup-1.3.0.exe (Linux / GitHub Codespaces).  Chay:  sh build-setup-exe.sh
set -e
cd "$(dirname "$0")"
if ! command -v makensis >/dev/null 2>&1; then
  echo "Cai NSIS..."; sudo apt-get update -qq && sudo apt-get install -y -qq nsis
fi
makensis -V2 installer/TetoSynthesia.nsi
ls -la TetoSynthesia-Setup-*.exe
