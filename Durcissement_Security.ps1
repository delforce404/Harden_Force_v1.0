# ===== Durcissement_Security.ps1 =====
$OutputEncoding = [System.Text.Encoding]::UTF8

# Dossiers
$base      = Split-Path -Parent $MyInvocation.MyCommand.Path
$reportDir = Join-Path $base "Reports"
$logDir    = Join-Path $base "Logs"
$listsDir  = Join-Path $base "lists"

foreach ($d in @($reportDir,$logDir)) { if (-not (Test-Path $d)) { New-Item -Path $d -ItemType Directory | Out-Null } }

# Vérifs listes
$machineFile = Join-Path $listsDir "Mode_Securitymachine.csv"
$userFile    = Join-Path $listsDir "Mode_Securityuser.csv"
if (-not (Test-Path $machineFile)) { Write-Host "Manque: $machineFile"; exit 1 }
if (-not (Test-Path $userFile))    { Write-Host "Manque: $userFile";    exit 1 }

# Import module
Import-Module (Join-Path $base "HardeningKitty.psm1")

# Timestamp
$ts = Get-Date -Format "yyyyMMdd-HHmmss"
$pc = $env:COMPUTERNAME

# ===== HailMary MACHINE (sans point de restauration) =====
$machReport = Join-Path $reportDir "HailMary_${pc}_Mode_Securitymachine_NoRestore_${ts}.csv"
$machLog    = Join-Path $logDir    "HailMary_${pc}_Mode_Securitymachine_NoRestore_${ts}.log"

Write-Host "Durcissement MACHINE (No Restore Point)…"
Invoke-HardeningKitty -Mode HailMary -Report -Log `
  -FileFindingList $machineFile `
  -ReportFile $machReport `
  -LogFile    $machLog `
  -SkipRestorePoint

Write-Host " - Rapport : $machReport"
Write-Host " - Log     : $machLog"
Write-Host ""

# ===== HailMary USER (sans point de restauration) =====
$userReport = Join-Path $reportDir "HailMary_${pc}_Mode_Securityuser_NoRestore_${ts}.csv"
$userLog    = Join-Path $logDir    "HailMary_${pc}_Mode_Securityuser_NoRestore_${ts}.log"

Write-Host "Durcissement USER (No Restore Point)…"
Invoke-HardeningKitty -Mode HailMary -Report -Log `
  -FileFindingList $userFile `
  -ReportFile $userReport `
  -LogFile    $userLog `
  -SkipRestorePoint

Write-Host " - Rapport : $userReport"
Write-Host " - Log     : $userLog"
Write-Host ""
