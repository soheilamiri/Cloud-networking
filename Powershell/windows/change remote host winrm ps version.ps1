Invoke-Command -ComputerName 172.16.144.14 -Credential administrator -ScriptBlock { $PsVersionTable.PSVersion } #-ConfigurationName Powershell.7
$session = New-PSSession 172.16.144.14 -ConfigurationName Powershell.7
Invoke-Command -Session $session -ScriptBlock { $PsVersionTable.PSVersion } 