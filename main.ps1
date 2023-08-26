Write-Host "BORZO_CERT_BOT powershell env v0.1" -ForegroundColor Blue

$currentpath = Split-Path -Parent $MyInvocation.MyCommand.Definition
Set-Location $currentpath
$validMenu = $false
do {
   Write-Host "Nabídka"
   Write-Host "[1]-Cert Enroll Process; [2]-Check Certificate; [3]-Get CRL; [4]-Get Certificate Chain" -ForegroundColor Yellow

    $menuSelect = Read-Host -Prompt 'Vyberte menu'
        if ([string]::IsNullOrWhiteSpace($validMenu)) {
            Write-Host "Neplatna volba"
        
        }else {
            if ($menuSelect -eq '1') {
                Start-Process pwsh.exe 'csr_db\enroll.ps1'
            }
        }

} while (-not $validMenu)