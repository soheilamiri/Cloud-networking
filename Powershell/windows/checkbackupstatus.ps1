$credserver = Get-Credential
$todaydate = get-date -Format "yymmdd"
$servername = "NATVPN"
$backuppath = "E:\Config-file\server-config\NATVPN\$todaydate"
set-Item WSMan:\localhost\Client\TrustedHosts -Value solar.ficld.ir -Force
$todaydate2= Get-Date -Format "M-d-yyyy"
$backuppathtor309 = "E:\Config-file\SW1-3064-TOR309\$todaydate2\"

Invoke-Command -ComputerName solar.ficld.ir -Credential $credserver -ScriptBlock {
    Backup from SW1-3064-TOR309
    if ((Get-ChildItem -Path  $($using:backuppathtor309).Count -eq 0) {
             Write-Output "Message.tor: successfull"
             Write-Output "Statistic.tor: 1"
             $status = "up"
    }  
}