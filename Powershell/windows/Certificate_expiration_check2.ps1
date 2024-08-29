# Example: .\Certificate_expiration_check2.ps1 -filepath .\URLlist.txt | fl
[CmdletBinding()]
param (
    [Parameter(Mandatory=$true)]
    [string]
    $filepath,

    [int]
    $Port = 443
)
# Read each line (URL) from the file
$Urls = Get-Content -Path $FilePath
foreach ($ComputerName in $Urls) {

$Certificate = $null
$TcpClient = New-Object -TypeName System.Net.Sockets.TcpClient
try {

    $TcpClient.Connect($ComputerName, $Port)
    $TcpStream = $TcpClient.GetStream()

    $Callback = { param($sender, $cert, $chain, $errors) return $true }

    $SslStream = New-Object -TypeName System.Net.Security.SslStream -ArgumentList @($TcpStream, $true, $Callback)
    try {

        $SslStream.AuthenticateAsClient('')
        $Certificate = $SslStream.RemoteCertificate

    } finally {
        $SslStream.Dispose()
    }

} finally {
    $TcpClient.Dispose()
}

if ($Certificate) {
    if ($Certificate -isnot [System.Security.Cryptography.X509Certificates.X509Certificate2]) {
        $Certificate = New-Object -TypeName System.Security.Cryptography.X509Certificates.X509Certificate2 -ArgumentList $Certificate
    }

    #Write-Output $Certificate 
    #Write-Output $Certificate.NotAfter
}


#days difference between two dates
Write-Output $ComputerName
$edate = $Certificate.NotAfter
$sdate = get-date -Format MM/dd/yyyy
$timediff = New-TimeSpan -Start $sdate -End $edate
write-output $timediff.Days
}