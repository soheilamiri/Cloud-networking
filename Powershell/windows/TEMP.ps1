$host= "Powershell\Serverlist.txt"
$username = "SYSADMIN"
$sshkey = "C:\Users\Administrator\.ssh\id_rsa"



$remotesession = new-PSSession -HostName $Host -Port 4141 -UserName $username -KeyFilePath $sshkey
$remotesession
#get DATA from remote host
    Invoke-Command -Session $remotesession -ScriptBlock {
        $($using:remotetime)
}


$servername="temp-1"
$remotehosts="C:\Users\Soheil\GitHub\Cloud-networking\Powershell\Serverlist.txt"
$Creds=Get-Credential

#prepare Deployer configuration
#set-Item WSMan:\localhost\Client\TrustedHosts -Value $remotehosts -force
$remotsession=New-PSSession -ComputerName IP_1,IP_2 -Credential $Creds -Name rtunnel
$remotsession

Invoke-Command -Session $remotsession -ScriptBlock {
    Write-Output "start configuration on $($env:COMPUTERNAME)"
    function My-command
    {
        Get-WindowsUpdate    
    }
    My-command
}