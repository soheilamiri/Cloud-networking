<# host have no internal access
1- Network
    1.1- Allow ICMP
2- install Tools
    2.1-install powershell
    2.2- install choco
3- Apply OS configuration
    3.1- set time
    3.2- rename computer
    3.3- Apply RRS config

#>
#Server parameter INPUT
$servername="temp-1"
$remotehosts="172.25.12.132"
$Creds=Get-Credential

#prepare Deployer configuration
#trust to remote hosts
set-Item WSMan:\localhost\Client\TrustedHosts -Value $remotehosts -force

$remotsession=New-PSSession -ComputerName $remotehosts -Credential $Creds -Name rtunnel
#copy files to remote host
Copy-Item "E:\Software\05- cloud\02- microsoft\PowerShell-7.4.3-win-x64.msi" -Destination "C:\Users\Administrator\AppData\Local\Temp\" -ToSession $remotsession
$remotsession=New-PSSession -ComputerName $remotehosts -Credential $Creds

#1- network config
Invoke-Command -Session $remotsession -ScriptBlock {
    Write-Output "start configuration on $($env:COMPUTERNAME)"
    function postconfig-network
    {
        New-NetFirewallRule -Name "NOC-Allow-ICMP" -DisplayName "NOC-Allow-ICMP" -Description "by-NOC-Orchestrator-echosystem" -Protocol icmpv4 -IcmpType 8 -Enabled True -Profile Domain,Private,Public -Action allow 
        Get-NetAdapterRss -Name ether* | Enable-NetAdapterRss    
    }
    postconfig-network
}
#install Tools
Invoke-Command -Session $remotsession -ScriptBlock {
    Write-Output "start configuration on $($env:COMPUTERNAME)"
    function postconfig-tools
        msiexec.exe C:\Users\Administrator\AppData\Local\Temp\PowerShell-7.4.3-win-x64.msi /quiet ENABLE_PSREMOTING=1
        #Invoke-WebRequest -Uri https://aka.ms/install-powershell.ps1 -OutFile install-powershell.ps1; ./install-powershell.ps1
        #cd c:\Users\Administrator\AppData\Local\Microsoft\powershell\
        #.\pwsh.exe -noprofile -command enable-PSRemoting
        Start-Sleep -Seconds 10
        #install choco
        Set-ExecutionPolicy Bypass -Scope Process -Force; [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072; iex ((New-Object System.Net.WebClient).DownloadString('https://community.chocolatey.org/install.ps1'))
        Start-Sleep -Seconds 10
        Write-Output "$($env:COMPUTERNAME) will go to check online update repository."
        choco install winget vim ntop.portable -y --no-progress
    }
    postconfig-tools
    }


    Invoke-Command -Session $remotsession -ScriptBlock {
        Write-Output "start configuration on $($env:COMPUTERNAME)"
        function postconfig-os
        {
            Set-TimeZone -Name "Iran Standard Time"
            rename-Computer -NewName $($using:servername) -Force
            Start-Sleep -Seconds 10
            Write-Output "$($env:COMPUTERNAME) is going to be restart in 20 sec."
            Restart-Computer -Force
        }
        postconfig-os
    }
 

Disconnect-PSSession -Session $remotsession
Remove-PSSession -Session $remotsession
Get-PSSession
