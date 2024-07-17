
$Creds=Get-Credential

$remotsession=New-PSSession -ComputerName 192.168.75.231 -Credential $Creds
Invoke-Command -Session $remotsession -ScriptBlock {
    function Test-PendingReboot
    {
     if (Get-ChildItem "HKLM:\Software\Microsoft\Windows\CurrentVersion\Component Based Servicing\RebootPending" -EA Ignore) { return $true }
     if (Get-Item "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\WindowsUpdate\Auto Update\RebootRequired" -EA Ignore) { return $true }
     if (Get-ItemProperty "HKLM:\SYSTEM\CurrentControlSet\Control\Session Manager" -Name PendingFileRenameOperations -EA Ignore) { return $true }
     try { 
       $util = [wmiclass]"\\.\root\ccm\clientsdk:CCM_ClientUtilities"
       $status = $util.DetermineIfRebootPending()
       if(($status -ne $null) -and $status.RebootPending){
         return $true
       }
     }catch{}
     
     return $false
    }
    Write-Output "$($env:COMPUTERNAME) need to be start"
    Test-PendingReboot
    }
Disconnect-PSSession -Session $remotsession
Remove-PSSession -Session $remotsession
Get-PSSession