# TetoSynthesia Setup (GUI, WinForms) - cai vao %LOCALAPPDATA%\Programs, khong can Admin
param([switch]$Silent, [string]$Dir)
$ErrorActionPreference = 'Stop'
Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName System.Drawing
[System.Windows.Forms.Application]::EnableVisualStyles()

$Src     = Split-Path -Parent (Split-Path -Parent $MyInvocation.MyCommand.Path)
$Version = '1.3.0'
$vi      = ([System.Globalization.CultureInfo]::CurrentUICulture.Name -like 'vi*')
function L($vn, $en) { if ($vi) { $vn } else { $en } }
$DefaultDir = Join-Path $env:LOCALAPPDATA 'Programs\TetoSynthesia'
if (-not $Dir) { $Dir = $DefaultDir }

function Find-Browser {
  $c = @(
    "$env:ProgramFiles\Google\Chrome\Application\chrome.exe",
    "${env:ProgramFiles(x86)}\Google\Chrome\Application\chrome.exe",
    "$env:LOCALAPPDATA\Google\Chrome\Application\chrome.exe",
    "${env:ProgramFiles(x86)}\Microsoft\Edge\Application\msedge.exe",
    "$env:ProgramFiles\Microsoft\Edge\Application\msedge.exe")
  foreach ($p in $c) { if ($p -and (Test-Path $p)) { return $p } }
  return $null
}

function New-Shortcut($lnk, $dest) {
  $ws = New-Object -ComObject WScript.Shell
  $sc = $ws.CreateShortcut($lnk)
  $html = Join-Path $dest 'TetoSynthesia.html'
  $browser = Find-Browser
  if ($browser) {
    $url = 'file:///' + ($html -replace '\\', '/')
    $prof = Join-Path $env:LOCALAPPDATA 'TetoSynthesia\profile'
    $sc.TargetPath = $browser
    $sc.Arguments = '--app="' + $url + '" --user-data-dir="' + $prof + '" --start-maximized'
  } else {
    $sc.TargetPath = $html
  }
  $sc.WorkingDirectory = $dest
  $sc.IconLocation = (Join-Path $dest 'assets\icon.ico') + ',0'
  $sc.Description = 'TetoSynthesia - Black MIDI Player'
  $sc.Save()
}

function Do-Install($dest, $desktop, $startMenu, $report) {
  & $report 5 (L 'Dang tao thu muc...' 'Creating folder...')
  New-Item -ItemType Directory -Force -Path $dest | Out-Null
  New-Item -ItemType Directory -Force -Path (Join-Path $dest 'assets') | Out-Null
  & $report 20 (L 'Dang chep tep ung dung...' 'Copying application files...')
  foreach ($f in 'TetoSynthesia.html','TetoSynthesia.bat','logo.png','README-VI.md') {
    Copy-Item -Force (Join-Path $Src $f) (Join-Path $dest $f)
  }
  Copy-Item -Force -Recurse (Join-Path $Src 'assets\*') (Join-Path $dest 'assets')
  & $report 50 (L 'Dang tao bo go cai dat...' 'Creating uninstaller...')
  Copy-Item -Force (Join-Path $Src 'installer\Uninstall.ps1') (Join-Path $dest 'Uninstall.ps1')
  Set-Content -Path (Join-Path $dest 'Uninstall.bat') -Encoding ASCII -Value ('@echo off' + "`r`n" + 'powershell.exe -NoProfile -ExecutionPolicy Bypass -STA -WindowStyle Hidden -File "%~dp0Uninstall.ps1"')
  & $report 65 (L 'Dang tao bieu tuong (logo)...' 'Creating shortcuts (logo)...')
  $sm = Join-Path $env:APPDATA 'Microsoft\Windows\Start Menu\Programs'
  if ($startMenu) { New-Shortcut (Join-Path $sm 'TetoSynthesia.lnk') $dest }
  if ($desktop)   { New-Shortcut (Join-Path ([Environment]::GetFolderPath('Desktop')) 'TetoSynthesia.lnk') $dest }
  & $report 85 (L 'Dang dang ky voi Windows...' 'Registering with Windows...')
  $k = 'HKCU:\Software\Microsoft\Windows\CurrentVersion\Uninstall\TetoSynthesia'
  New-Item -Force -Path $k | Out-Null
  $props = @{
    DisplayName = 'TetoSynthesia'; DisplayVersion = $Version; Publisher = 'TetoSynthesia'
    DisplayIcon = (Join-Path $dest 'assets\icon.ico'); InstallLocation = $dest
    UninstallString = ('"' + (Join-Path $dest 'Uninstall.bat') + '"'); NoModify = 1; NoRepair = 1
  }
  foreach ($n in $props.Keys) { Set-ItemProperty -Path $k -Name $n -Value $props[$n] }
  & $report 100 (L 'Hoan tat!' 'Done!')
}

if ($Silent) {
  Do-Install $Dir $true $true { param($p, $t) }
  exit 0
}

# ---------------- GUI ----------------
$bg = [System.Drawing.Color]::FromArgb(0,0,0)
$fg = [System.Drawing.Color]::FromArgb(242,242,242)
$dim = [System.Drawing.Color]::FromArgb(143,143,143)
$form = New-Object System.Windows.Forms.Form
$form.Text = 'TetoSynthesia Setup'
$form.ClientSize = New-Object System.Drawing.Size(620, 380)
$form.StartPosition = 'CenterScreen'
$form.FormBorderStyle = 'FixedDialog'; $form.MaximizeBox = $false
$form.BackColor = $bg; $form.ForeColor = $fg
$form.Font = New-Object System.Drawing.Font('Segoe UI', 9)
try { $form.Icon = New-Object System.Drawing.Icon((Join-Path $Src 'assets\icon.ico')) } catch {}

$pic = New-Object System.Windows.Forms.PictureBox
$pic.Location = New-Object System.Drawing.Point(24, 24); $pic.Size = New-Object System.Drawing.Size(150, 150)
$pic.SizeMode = 'Zoom'; $pic.BackColor = $bg
$pic.Image = [System.Drawing.Image]::FromFile((Join-Path $Src 'logo.png'))
$form.Controls.Add($pic)

function Add-Label($text, $x, $y, $w, $h, $size, $style, $color) {
  $l = New-Object System.Windows.Forms.Label
  $l.Text = $text; $l.Location = New-Object System.Drawing.Point($x, $y); $l.Size = New-Object System.Drawing.Size($w, $h)
  $l.Font = New-Object System.Drawing.Font('Segoe UI', $size, $style); $l.ForeColor = $color; $l.BackColor = $bg
  $form.Controls.Add($l); return $l
}
$null = Add-Label 'TETOSYNTHESIA' 200 28 400 36 20 ([System.Drawing.FontStyle]::Bold) $fg
$null = Add-Label ('Black MIDI Player  v' + $Version) 202 66 400 20 9 ([System.Drawing.FontStyle]::Regular) $dim
$null = Add-Label (L 'Thu muc cai dat:' 'Install folder:') 202 112 300 18 9 ([System.Drawing.FontStyle]::Regular) $fg

$txt = New-Object System.Windows.Forms.TextBox
$txt.Location = New-Object System.Drawing.Point(202, 134); $txt.Size = New-Object System.Drawing.Size(300, 24)
$txt.Text = $Dir; $txt.BackColor = [System.Drawing.Color]::FromArgb(20,20,20); $txt.ForeColor = $fg; $txt.BorderStyle = 'FixedSingle'
$form.Controls.Add($txt)
$btnBr = New-Object System.Windows.Forms.Button
$btnBr.Text = (L 'Chon...' 'Browse...'); $btnBr.Location = New-Object System.Drawing.Point(512, 132); $btnBr.Size = New-Object System.Drawing.Size(84, 28)
$btnBr.FlatStyle = 'Flat'; $btnBr.ForeColor = $fg; $btnBr.BackColor = [System.Drawing.Color]::FromArgb(30,30,30)
$btnBr.Add_Click({
  $fd = New-Object System.Windows.Forms.FolderBrowserDialog
  if ($fd.ShowDialog() -eq 'OK') { $txt.Text = (Join-Path $fd.SelectedPath 'TetoSynthesia') }
})
$form.Controls.Add($btnBr)

function Add-Check($text, $y) {
  $c = New-Object System.Windows.Forms.CheckBox
  $c.Text = $text; $c.Location = New-Object System.Drawing.Point(202, $y); $c.Size = New-Object System.Drawing.Size(390, 24)
  $c.Checked = $true; $c.ForeColor = $fg; $c.BackColor = $bg
  $form.Controls.Add($c); return $c
}
$chkDesk = Add-Check (L 'Tao bieu tuong (logo) ngoai Desktop' 'Create a Desktop shortcut (logo)') 176
$chkMenu = Add-Check (L 'Them vao Start Menu' 'Add to Start Menu') 204
$chkRun  = Add-Check (L 'Mo TetoSynthesia sau khi cai xong' 'Launch TetoSynthesia when finished') 232

$bar = New-Object System.Windows.Forms.ProgressBar
$bar.Location = New-Object System.Drawing.Point(24, 300); $bar.Size = New-Object System.Drawing.Size(572, 14); $bar.Minimum = 0; $bar.Maximum = 100
$form.Controls.Add($bar)
$status = Add-Label '' 24 320 400 20 9 ([System.Drawing.FontStyle]::Regular) $dim

$btnGo = New-Object System.Windows.Forms.Button
$btnGo.Text = (L 'CAI DAT' 'INSTALL'); $btnGo.Location = New-Object System.Drawing.Point(486, 332); $btnGo.Size = New-Object System.Drawing.Size(110, 34)
$btnGo.FlatStyle = 'Flat'; $btnGo.ForeColor = [System.Drawing.Color]::Black; $btnGo.BackColor = $fg
$btnGo.Font = New-Object System.Drawing.Font('Segoe UI', 9, [System.Drawing.FontStyle]::Bold)
$form.Controls.Add($btnGo)
$btnCancel = New-Object System.Windows.Forms.Button
$btnCancel.Text = (L 'Huy' 'Cancel'); $btnCancel.Location = New-Object System.Drawing.Point(396, 332); $btnCancel.Size = New-Object System.Drawing.Size(80, 34)
$btnCancel.FlatStyle = 'Flat'; $btnCancel.ForeColor = $fg; $btnCancel.BackColor = [System.Drawing.Color]::FromArgb(30,30,30)
$btnCancel.Add_Click({ $form.Close() })
$form.Controls.Add($btnCancel)

$script:finished = $false
$btnGo.Add_Click({
  if ($script:finished) {
    if ($chkRun.Checked) {
      $lnk = Join-Path ([Environment]::GetFolderPath('Desktop')) 'TetoSynthesia.lnk'
      $dest = $txt.Text
      if (Test-Path $lnk) { Start-Process $lnk } else { Start-Process (Join-Path $dest 'TetoSynthesia.bat') }
    }
    $form.Close(); return
  }
  $btnGo.Enabled = $false; $btnCancel.Enabled = $false; $txt.Enabled = $false; $btnBr.Enabled = $false
  try {
    $rep = { param($p, $t) $bar.Value = $p; $status.Text = $t; [System.Windows.Forms.Application]::DoEvents(); Start-Sleep -Milliseconds 150 }
    Do-Install $txt.Text $chkDesk.Checked $chkMenu.Checked $rep
    $script:finished = $true
    $btnGo.Text = (L 'HOAN TAT' 'FINISH'); $btnGo.Enabled = $true
  } catch {
    [System.Windows.Forms.MessageBox]::Show($_.Exception.Message, 'TetoSynthesia Setup', 'OK', 'Error') | Out-Null
    $btnGo.Enabled = $true; $btnCancel.Enabled = $true; $txt.Enabled = $true; $btnBr.Enabled = $true
  }
})

[void]$form.ShowDialog()
