Set-StrictMode -version latest
$server= "172.24.0.40"
$username = "ubuntu"
#$sshkey = "C:\Users\Administrator\.ssh\id_rsa"
$sshkey = "C:\Users\Soheil\.ssh\Privatekey"



$remotesession = new-PSSession -HostName $server -Port 4141 -UserName $username -KeyFilePath $sshkey
#get DATA from remote host
$status =  Invoke-Command -Session $remotesession -ScriptBlock {
        if ( Get-ChildItem -Path /backups/database/ | Where-Object {$_.CreationTime -ge (get-date).date} | Where-Object {$_.Size -gt (200*1MB)}) {
            Write-Output "OK"
            return $status
        } else {
            Write-Output "failed"
            return $status
        }
}

if ($status="Ok") {
    Write-Output "Message.OpenStack_DB: Successful"
        Write-Output "Statistic.OpenStack_DB: 1"
        $status = "UP"
} else {
    Write-Output "Message.OpenStack_DB: failed"
        Write-Output "Statistic.OpenStack_DB: 0"
        $status = "down"
}


<#
        Write-Output "Message.Nginx_ENT_1: failed"
        Write-Output "Statistic.Nginx_ENT_1: 0"
        $status = "down" 
#>