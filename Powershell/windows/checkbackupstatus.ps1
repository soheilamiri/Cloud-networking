$credserver = Get-Credential
$todaydate = get-date -Format "yymmdd"
set-Item WSMan:\localhost\Client\TrustedHosts -Value solar.ficld.ir -Force
$backuppath2 = "E:\Config-file\server-config\Reverse-proxy\$todaydate\"


Invoke-Command -ComputerName solar.ficld.ir -Credential $credserver -ScriptBlock {
    if ((Get-ChildItem -Path  $($using:backuppath2).Count -eq 2) {
        Write-Output "Message.Nginx_ENT_1: successfull"
        Write-Output "Statistic.Nginx_ENT_1: 1"
        $status = "up"
} 
}