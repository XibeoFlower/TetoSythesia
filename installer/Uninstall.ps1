# TetoSynthesia Uninstall
Add-Type -AssemblyName System.Windows.Forms
$vi = ([System.Globalization.CultureInfo]::CurrentUICulture.Name -like 'vi*')
$msg = if ($vi) { 'Go cai dat TetoSynthesia khoi may nay?' } else { 'Remove TetoSynthesia from this computer?' }
if ([System.Windows.Forms.MessageBox]::Show($msg, 'TetoSynthesia', 'YesNo', 'Question') -ne 'Yes') { exit 0 }
$dest = Split-Path -Parent $MyInvocation.MyCommand.Path
foreach ($lnk in @((Join-Path ([Environment]::GetFolderPath('Desktop')) 'TetoSynthesia.lnk'),
                   (Join-Path $env:APPDATA 'Microsoft\Windows\Start Menu\Programs\TetoSynthesia.lnk'))) {
  if (Test-Path $lnk) { Remove-Item -Force $lnk }
}
Remove-Item -Force -Recurse -ErrorAction SilentlyContinue (Join-Path $env:LOCALAPPDATA 'TetoSynthesia')
Remove-Item -Force -Recurse -ErrorAction SilentlyContinue 'HKCU:\Software\Microsoft\Windows\CurrentVersion\Uninstall\TetoSynthesia'
# xoa thu muc cai dat sau khi script thoat (script dang nam trong do)
Start-Process cmd.exe -WindowStyle Hidden -ArgumentList ('/c timeout /t 2 /nobreak >nul & rmdir /s /q "' + $dest + '"')
