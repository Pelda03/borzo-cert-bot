function Generate-PrivateKey {
    param (
        [string]$userID,
        [string]$endpath
    )

    $counter = 0
    do {
        $counter++
        $keyname = "key$userID$counter.pem"
        $keyPath = Join-Path -Path $endpath -ChildPath $keyname
    } while (Test-Path $keyPath)
    
    openssl genrsa -out $keyPath 2048
    Write-Host "Generated private key: $keyPath"
    return $keyPath
}

function GetUserInput {
    $country = "CZ"
    $organization = "MDGP"
    $email = "$userID@mdgp.cz"
    $commonName = Read-Host "Enter Common Name (CN):"
    $dnsNames = @()
    do {
        $dnsName = Read-Host "Enter DNS Name (or leave empty to finish):"
        if ($dnsName -ne "") {
            $dnsNames += "DNS.$($dnsNames.Count) = $dnsName"
        }
    } while ($dnsName -ne "")

    return $country, $organization, $email, $commonName, $dnsNames
}

function Generate-ConfigFile {
    param (
        [string]$outputPath,
        [string]$country,
        [string]$organization,
        [string]$email,
        [string]$commonName,
        [string[]]$dnsNames
    )

    $dnsNamesList = $dnsNames -join ","
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
subjectAltName = DNS:$dnsNamesList

"@

    $opensslConfig | Out-File -FilePath $outputPath -Encoding UTF8
    Write-Host "OpenSSL configuration file generated at: $outputPath"
}

# Main script

Write-Host "BORZO_CERT_BOT OPENSSL"

$currentpath = Split-Path -Parent $MyInvocation.MyCommand.Definition
Set-Location $currentpath

$endpath = 'csr_db'
$FolderPath = $endpath

$userID = Read-Host -Prompt 'Enter unique userCertID'

$keyPath = Generate-PrivateKey -userID $userID -endpath $endpath

$country, $organization, $email, $commonName, $dnsNames = GetUserInput

$outputPath = Join-Path -Path $endpath -ChildPath "$commonName.cnf"
Generate-ConfigFile -outputPath $outputPath -country $country -organization $organization -email $email -commonName $commonName -dnsNames $dnsNames

Generate-CertificateRequest -outputPath $outputPath -keyPath $keyPath

Pause
