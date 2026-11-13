@echo off
rem TetoSynthesia v1.3.0 - mo o dang cua so app (Chrome/Edge --app), neu khong co thi mo bang trinh duyet mac dinh
setlocal
set "APP=%~dp0TetoSynthesia.html"
set "URL=file:///%APP:\=/%"
set "PROF=%LOCALAPPDATA%\TetoSynthesia\profile"
for %%B in ("%ProgramFiles%\Google\Chrome\Application\chrome.exe" "%ProgramFiles(x86)%\Google\Chrome\Application\chrome.exe" "%LocalAppData%\Google\Chrome\Application\chrome.exe" "%ProgramFiles(x86)%\Microsoft\Edge\Application\msedge.exe" "%ProgramFiles%\Microsoft\Edge\Application\msedge.exe") do (
  if exist %%B (
    start "" %%B --app="%URL%" --user-data-dir="%PROF%" --start-maximized
    exit /b 0
  )
)
start "" "%APP%"
