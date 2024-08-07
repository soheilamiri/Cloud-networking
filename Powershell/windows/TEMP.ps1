$host= "172.24.0.40"
$username = "ubuntu"
$sshkey = "C:\Users\Administrator\.ssh\id_rsa"



$remotesession = new-PSSession -HostName $Host -Port 4141 -UserName $username -KeyFilePath $sshkey
$remotesession
#get DATA from remote host
    Invoke-Command -Session $remotesession -ScriptBlock {
        $($using:remotetime)
}