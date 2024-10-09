<# host have no internal access
1- Network
    1.1- Allow ICMP
2- install Tools
    2.1-install powershell and configure for remote powershell profile
    2.2- install choco
3- Apply OS configuration
    3.1- set time
    3.2- rename computer
    3.3- Apply RRS config

#>
#Server parameter INPUT
$servername="temp-1"
$remotehosts="172.18.97.207"
$Creds=Get-Credential
$newuser = "sysadmin"

#prepare Deployer configuration
#set-Item WSMan:\localhost\Client\TrustedHosts -Value $remotehosts -force
$remotsession=New-PSSession -ComputerName $remotehosts -Credential $Creds -Name rtunnel
$remotsession
#copy files to remote host
Copy-Item "E:\Software\05- cloud\02- microsoft\PowerShell-7.4.4-win-x64.msi" -Destination "C:\Users\Administrator\AppData\Local\Temp\" -ToSession $remotsession
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
$remotsession=New-PSSession -ComputerName $remotehosts -Credential $Creds -Name rtunnel
$remotsession
Invoke-Command -Session $remotsession -ScriptBlock {
    Write-Output "start configuration on $($env:COMPUTERNAME)"
    function postconfig-tools
    {
        #install PWSH via diresr URL
        #Invoke-WebRequest -Uri https://aka.ms/install-powershell.ps1 -OutFile install-powershell.ps1; ./install-powershell.ps1
        Write-Output "installing powershell"
        Start-Process -FilePath "msiexec.exe" -ArgumentList "/i C:\Users\Administrator\AppData\Local\Temp\PowerShell-7.4.4-win-x64.msi /quiet ENABLE_PSREMOTING=1" -Wait -Debug
        Start-Sleep -Seconds 10
        Write-Output "installing choco"
        Set-ExecutionPolicy Bypass -Scope Process -Force; [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072; iex ((New-Object System.Net.WebClient).DownloadString('https://community.chocolatey.org/install.ps1'))
        Start-Sleep -Seconds 10
        Write-Output "$($env:COMPUTERNAME) will go to check online update repository."
        choco install vim ntop.portable -y --no-progress
        #to install powershell via choco
        # choco install powershell-core
        cd c:\Users\Administrator\AppData\Local\Microsoft\powershell\
        .\pwsh.exe -noprofile -command enable-PSRemoting
        #Restart-Computer -Force
    }
    postconfig-tools
    }

#3- Apply OS configuration
$remotsession=New-PSSession -ComputerName $remotehosts -Credential $Creds -Name rtunnel
$remotsession
    Invoke-Command -Session $remotsession -ScriptBlock {
        Write-Output "start configuration on $($env:COMPUTERNAME)"
        function postconfig-os
        {
            Set-TimeZone -Name "Iran Standard Time"
            New-LocalUser -Name $($using:newuser) -FullName "System Operator" -Password (ConvertTo-SecureString "$R4solm8!0pZ" -AsPlainText -Force) -Description "Ceated By Noc user" -PasswordNeverExpires
            Add-LocalGroupMember -Group "Administrators" -Member $($using:newuser)
            powercfg /S SCHEME_MIN  # High Performance
            rename-Computer -NewName $($using:servername) -Force
            Write-Output "$($env:COMPUTERNAME) is going to be restart in 10 sec."
            Start-Sleep -Seconds 10
            Restart-Computer -Force
        }
        postconfig-os
    }
 

Disconnect-PSSession -Session $remotsession
Remove-PSSession -Session $remotsession
Get-PSSession
