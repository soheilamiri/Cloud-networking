#how run command : .\Watch.ps1 -Command "Get-Process" -Interval 5

param (
    [string]$Command,     # The command to run
    [int]$Interval = 2    # The interval between executions in seconds
)

while ($true) {
    Clear-Host
    Invoke-Expression $Command
    Start-Sleep -Seconds $Interval
}