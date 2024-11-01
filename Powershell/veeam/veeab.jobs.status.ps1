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
    $job_Result = (Get-VBRJob -Name $jobName).GetLastResult()
    $job_State = (Get-VBRJob -Name $jobName).GetLastState()
    $job_session = (Get-VBRJob -Name $jobName).FindLastSession()

    # Output the job information
    [PSCustomObject]@{
        JobName     = $jobName
        LastResult  = $job_Result
        LastState   = $job_State
        job_session = $job_session
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
if ( $job_session -eq $null )
{ $stat3=$stat4=$stat5=$stat6=0; }
else
{
$stat3=$job_session.jobtypestring;
$temp_stat4=$job_session.CreationTime;
$temp_stat5=$job_session.EndTime;
$stat4 = $temp_stat4.tostring("yyyy.MM.dd HH:mm")
$stat5 = $temp_stat5.tostring("yyyy.MM.dd HH:mm")
#Soheil_Debug <
# $stat1
# $stat2
# $stat3
# $stat4
# $stat5
#/> end of debug
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