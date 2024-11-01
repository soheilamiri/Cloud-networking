$servername="temp-1"
$remotehosts="172.15.1.11"
$username = "sysadmin"
$password = "M=WUd657tBxc877" | ConvertTo-SecureString -AsPlainText -Force

# Create a PSCredential object using the username and password
$credential = New-Object System.Management.Automation.PSCredential ($username, $password)

#prepare Deployer configuration
#set-Item WSMan:\localhost\Client\TrustedHosts -Value $remotehosts -force
$remotsession=New-PSSession -ComputerName $remotehosts -Credential $credential -Name rtunnel
$remotsession

Invoke-Command -Session $remotsession -ScriptBlock {
# Load the Veeam Backup module
#Import-Module Veeam.Backup.PowerShell

# Connect to Veeam Backup server (authentication may vary depending on environment)
#Connect-VBRServer -Server "localhost"

# Retrieve all Veeam Backup jobs
$job_name = Get-VBRJob
if ($job_name -ne $null)
{
# Iterate over each job and output its name, last result, and current state
foreach ($job in $job_name) {
    $jobName = $job.Name
    $lastResult = (Get-VBRJob -Name $jobName).GetLastResult()
    $lastState = (Get-VBRJob -Name $jobName).GetLastState()
    $lastSessionStats = (Get-VBRJob -Name $jobName).FindLastSession()

    # Output the job information
    [PSCustomObject]@{
        JobName     = $jobName
        LastResult  = $lastResult
        LastState   = $lastState
        LastSessionStats = $lastSessionStats
    }
    switch ($job_result) 
    { 
    "Success" { $stat1=0 } 
    "None" { $stat1=1 } 
    "Failed" { $stat1=2 } 
    default { $stat1=3 }
    }
   switch ($job_state) 
    { 
    "Stopped" { $stat2=0 } 
    "Starting" { $stat2=1 } 
    "Working" { $stat2=2 } 
    "Stopping" { $stat2=3 } 
    "Resuming" { $stat2=4 } 
    "Pausing" { $stat2=5 } 
    default { $stat2=6 }
    }
if ( $lastSessionStats -eq $null )
{ $stat3=$stat4=$stat5=$stat6=0; }
else
{
$stat3=$lastSessionStats.jobtypestring;
$temp_stat4=$lastSessionStats.CreationTime;
$temp_stat5=$lastSessionStats.EndTime;
$stat4 = $temp_stat4.tostring("yyyy.MM.dd HH:mm")
$stat5 = $temp_stat5.tostring("yyyy.MM.dd HH:mm")
}

}
# Disconnect from Veeam Backup server
#Disconnect-VBRServer

}
    else {
        Write-Host "Message: Can't find ""job_name"" argument. Check documentation."
        exit 1
        }

}