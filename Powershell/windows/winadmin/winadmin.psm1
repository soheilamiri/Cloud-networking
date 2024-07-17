function winadmin-applyposttask {
        
    Write-Output "this is post installation task "
}

function winadmin-PendingReboot {
        
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

function  winadmin-watch {
    
param (
    [string]$Command,     # The command to run
    [int]$Interval = 2    # The interval between executions in seconds
)

while ($true) {
    Clear-Host
    Invoke-Expression $Command
    Start-Sleep -Seconds $Interval
}
}


