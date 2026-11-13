@echo off
rem Build TetoSynthesia-Setup-1.3.0.exe tren Windows (can cai NSIS: https://nsis.sourceforge.io/Download)
setlocal
cd /d "%~dp0"
set "NSIS="
if exist "%ProgramFiles(x86)%\NSIS\makensis.exe" set "NSIS=%ProgramFiles(x86)%\NSIS\makensis.exe"
if exist "%ProgramFiles%\NSIS\makensis.exe" set "NSIS=%ProgramFiles%\NSIS\makensis.exe"
if "%NSIS%"=="" (
  echo Chua cai NSIS. Tai tai: https://nsis.sourceforge.io/Download
  pause
  exit /b 1
)
"%NSIS%" installer\TetoSynthesia.nsi
if errorlevel 1 (pause & exit /b 1)
echo Xong: %~dp0TetoSynthesia-Setup-1.3.0.exe
pause
