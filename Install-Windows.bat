@echo off
rem TetoSynthesia Setup - nhan dup de cai dat (khong can quyen Admin)
powershell.exe -NoProfile -ExecutionPolicy Bypass -STA -WindowStyle Hidden -File "%~dp0installer\Install.ps1"
if errorlevel 1 (
  echo.
  echo Cai dat that bai / Setup failed. Hay thu: chuot phai Install-Windows.bat ^> Run as administrator
  pause
)
