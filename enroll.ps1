Write-Host "BORZO_CERT_BOT OPENSSL"

$currentpath = Split-Path -Parent $MyInvocation.MyCommand.Definition
Set-Location $currentpath

$endpath = 'csr_db'
$FolderPath = $endpath

$userID = Read-Host -Prompt 'Enter unique userCertID'

function borzo_openssl_enroll {
    $counter = 0
    do {
        $counter++
        $keyname = "key$userID$counter.pem"
        $keyPath = Join-Path -Path $endpath -ChildPath $keyname
    } while (Test-Path $keyPath)
    
    openssl genrsa -out $keyPath 2048
    Write-Host "Generated private key: $keyPath"
}
borzo_openssl_enroll

function userCSRconfigCreate {
   
# Gather user input for the output folder
$outputFolder = Read-Host "Enter the path to the output folder for OpenSSL configurations:"
if (-not (Test-Path -Path $outputFolder -PathType Container)) {
    Write-Host "Creating output folder: $outputFolder"
    New-Item -Path $outputFolder -ItemType Directory | Out-Null
}

# Gather user inputs for the configuration
$country = Read-Host "Enter Country (C):"
$organization = Read-Host "Enter Organization (O):"
$email = Read-Host "Enter Email Address:"
$commonName = Read-Host "Enter Common Name (CN):"
$dnsNames = @()
do {
    $dnsName = Read-Host "Enter DNS Name (or leave empty to finish):"
    if ($dnsName -ne "") {
        $dnsNames += "DNS.$($dnsNames.Count) = $dnsName"
    }
} while ($dnsName -ne "")

# Construct the OpenSSL configuration content
$opensslConfig = @"
[req]
default_bits = 2048
distinguished_name = dn
prompt             = no
req_extensions = req_ext

[dn]
C="$country"
O="$organization"
emailAddress="$email"
CN="$commonName"

[req_ext]
subjectAltName = @alt_names

[alt_names]
$($dnsNames -join "`n")
"@

# Generate a unique file name
$fileName = "$commonName-$((Get-Date).ToString('yyyyMMddHHmmss')).cnf"
$outputPath = Join-Path -Path $outputFolder -ChildPath $fileName

# Write the OpenSSL configuration content to the file
$opensslConfig | Out-File -FilePath $outputPath -Encoding UTF8

Write-Host "OpenSSL configuration file generated at: $outputPath"
return $opensslConfig, $outputPath
}
userCSRconfigCreate

$opensslConfig, $outputPath = userCSRconfigCreate

function getcsr {
    $rqcounter = 0
    do {
        $rqcounter++
        $rqname = "csr$userID$rqcounter.csr"
        $rqPath = Join-Path -Path $endpath -ChildPath $rqname
    } while (Test-Path $rqPath)

    $keyPath = Join-Path -Path $endpath -ChildPath "key$userID$rqcounter.pem"
    $opensslConfig | Out-File -FilePath $outputPath -Encoding UTF8  # Write the config content to the file
    openssl req -new -config $outputPath -key $keyPath -out $rqPath
    Write-Host "Generated CSR: $rqPath"
}

getcsr


Pause