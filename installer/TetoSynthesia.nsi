; TetoSynthesia installer (NSIS). Build: makensis installer/TetoSynthesia.nsi  (chay tu thu muc goc TetoSynthesia/)
Unicode true
!define APP "TetoSynthesia"
!define VER "1.3.0"
!include "MUI2.nsh"

Name "${APP} ${VER}"
OutFile "..\${APP}-Setup-${VER}.exe"
InstallDir "$LOCALAPPDATA\Programs\${APP}"
RequestExecutionLevel user
SetCompressor /SOLID lzma

!define MUI_ICON "..\assets\icon.ico"
!define MUI_UNICON "..\assets\icon.ico"
!define MUI_WELCOMEFINISHPAGE_BITMAP "..\assets\nsis-welcome.bmp"
!define MUI_UNWELCOMEFINISHPAGE_BITMAP "..\assets\nsis-welcome.bmp"
!define MUI_HEADERIMAGE
!define MUI_HEADERIMAGE_BITMAP "..\assets\nsis-header.bmp"
!define MUI_BGCOLOR "000000"
!define MUI_TEXTCOLOR "F2F2F2"
!define MUI_FINISHPAGE_RUN "$INSTDIR\TetoSynthesia.bat"
!define MUI_FINISHPAGE_RUN_TEXT "Launch ${APP}"
!define MUI_FINISHPAGE_LINK "Join our Discord"
!define MUI_FINISHPAGE_LINK_LOCATION "https://discord.gg/peaqm6uqgB"

!insertmacro MUI_PAGE_WELCOME
!insertmacro MUI_PAGE_LICENSE "..\LICENSE.txt"
!insertmacro MUI_PAGE_DIRECTORY
!insertmacro MUI_PAGE_INSTFILES
!insertmacro MUI_PAGE_FINISH
!insertmacro MUI_UNPAGE_CONFIRM
!insertmacro MUI_UNPAGE_INSTFILES
!insertmacro MUI_LANGUAGE "English"
!insertmacro MUI_LANGUAGE "Vietnamese"

Section "Install"
  SetOutPath "$INSTDIR"
  File "..\TetoSynthesia.html"
  File "..\TetoSynthesia.bat"
  File "..\logo.png"
  File "..\README-VI.md"
  File "..\LICENSE.txt"
  SetOutPath "$INSTDIR\assets"
  File "..\assets\icon.ico"
  SetOutPath "$INSTDIR"
  CreateShortCut "$DESKTOP\${APP}.lnk" "$INSTDIR\TetoSynthesia.bat" "" "$INSTDIR\assets\icon.ico" 0 SW_SHOWMINIMIZED
  CreateDirectory "$SMPROGRAMS\${APP}"
  CreateShortCut "$SMPROGRAMS\${APP}\${APP}.lnk" "$INSTDIR\TetoSynthesia.bat" "" "$INSTDIR\assets\icon.ico" 0 SW_SHOWMINIMIZED
  WriteINIStr "$SMPROGRAMS\${APP}\Discord.url" "InternetShortcut" "URL" "https://discord.gg/peaqm6uqgB"
  WriteUninstaller "$INSTDIR\Uninstall.exe"
  WriteRegStr HKCU "Software\Microsoft\Windows\CurrentVersion\Uninstall\${APP}" "DisplayName" "${APP}"
  WriteRegStr HKCU "Software\Microsoft\Windows\CurrentVersion\Uninstall\${APP}" "DisplayVersion" "${VER}"
  WriteRegStr HKCU "Software\Microsoft\Windows\CurrentVersion\Uninstall\${APP}" "DisplayIcon" "$INSTDIR\assets\icon.ico"
  WriteRegStr HKCU "Software\Microsoft\Windows\CurrentVersion\Uninstall\${APP}" "UninstallString" '"$INSTDIR\Uninstall.exe"'
SectionEnd

Section "Uninstall"
  Delete "$DESKTOP\${APP}.lnk"
  RMDir /r "$SMPROGRAMS\${APP}"
  RMDir /r "$INSTDIR"
  RMDir /r "$LOCALAPPDATA\${APP}"
  DeleteRegKey HKCU "Software\Microsoft\Windows\CurrentVersion\Uninstall\${APP}"
SectionEnd
