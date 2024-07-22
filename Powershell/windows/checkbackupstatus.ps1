$credserver = Get-Credential
$todaydate = get-date -Format "yymmdd"
$servername = "NATVPN"
$backuppath = "E:\Config-file\server-config\NATVPN\$todaydate"
set-Item WSMan:\localhost\Client\TrustedHosts -Value solar.ficld.ir -Force

Invoke-Command -ComputerName solar.ficld.ir -Credential $credserver -ScriptBlock {
    (Get-ChildItem -Path $backuppath).count
}