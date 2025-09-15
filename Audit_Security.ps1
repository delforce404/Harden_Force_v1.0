# ===== Audit_Security.ps1 =====
$OutputEncoding = [System.Text.Encoding]::UTF8

# Dossiers
$base      = Split-Path -Parent $MyInvocation.MyCommand.Path
$backupDir = Join-Path $base "Backups"
$reportDir = Join-Path $base "Reports"
$logDir    = Join-Path $base "Logs"
$listsDir  = Join-Path $base "lists"

# Création des répertoires
foreach ($d in @($backupDir,$reportDir,$logDir)) { if (-not (Test-Path $d)) { New-Item -Path $d -ItemType Directory | Out-Null } }

# Vérifs listes
$machineFile = Join-Path $listsDir "Mode_Securitymachine.csv"
$userFile    = Join-Path $listsDir "Mode_Securityuser.csv"
if (-not (Test-Path $machineFile)) { Write-Host "Manque: $machineFile"; exit 1 }
if (-not (Test-Path $userFile))    { Write-Host "Manque: $userFile";    exit 1 }

# Import du module (dans le même dossier)
Import-Module (Join-Path $base "HardeningKitty.psm1")

# Horodatage
$ts = Get-Date -Format "yyyyMMdd-HHmmss"
$pc = $env:COMPUTERNAME

# ===== Backups (machine & user) =====
$machineBackup = Join-Path $backupDir "Backup_${pc}_${ts}_Machine.csv"
$userBackup    = Join-Path $backupDir "Backup_${pc}_${ts}_User.csv"

Invoke-HardeningKitty -Mode Config -Backup -BackupFile $machineBackup -FileFindingList $machineFile
Invoke-HardeningKitty -Mode Config -Backup -BackupFile $userBackup    -FileFindingList $userFile

# ===== Audit Machine =====
$machReport = Join-Path $reportDir "Audit_${pc}_Mode_Securitymachine_${ts}.csv"
$machLog    = Join-Path $logDir    "Audit_${pc}_Mode_Securitymachine_${ts}.log"

Invoke-HardeningKitty -Mode Audit -Report -Log `
  -FileFindingList $machineFile `
  -ReportFile $machReport `
  -LogFile    $machLog

Write-Host "Audit MACHINE terminé."
Write-Host " - Rapport : $machReport"
Write-Host " - Log     : $machLog"
Write-Host ""

# ===== Audit User =====
$userReport = Join-Path $reportDir "Audit_${pc}_Mode_Securityuser_${ts}.csv"
$userLog    = Join-Path $logDir    "Audit_${pc}_Mode_Securityuser_${ts}.log"

Invoke-HardeningKitty -Mode Audit -Report -Log `
  -FileFindingList $userFile `
  -ReportFile $userReport `
  -LogFile    $userLog

Write-Host "Audit USER terminé."
Write-Host " - Rapport : $userReport"
Write-Host " - Log     : $userLog"
Write-Host ""
