#remote host
$Filepath = "C:\Users\Soheil\OneDrive\Desktop\Server-list.txt"
$Serversname = Get-Content -Path $Filepath
$remotetime = get-date

$mgmtport = 4141
#user information
$username = "user"
$sshkey = "C:\Users\Soheil\.ssh\Privatekey"

foreach ($serverhost in $Serversname ) {
    # connecting to remote servers
    $remotesession = New-PSSession -HostName $serverhost -Port $mgmtport -UserName $username -KeyFilePath $sshkey
    #get DATA from remote host
    Invoke-Command -Session $remotesession -ScriptBlock {
        $($using:remotetime)
}
# Calculate the time difference
$localtime = Get-Date
$timespan = New-TimeSpan -Start $remotetime -End $localtime
$diffrence = $timespan.Minutes
if ($timespan.TotalMinutes -le 2) {
    Write-Output "===================="
    Write-Output "Server name:$serverhost"
    Write-Output "Message:healthy"
    Write-Output "statistic:$diffrence"
    Write-Output "===================="    
} else {
    Write-Output "===================="
    Write-Output "Server name:$serverhost"
    Write-Output "Message:Unhealthy"
    Write-Output "statistic:$diffrence"
    Write-Output "===================="
}
}


