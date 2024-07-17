#manifest
New-ModuleManifest -Path "C:\Users\Soheil\Cloud-networking-1\Powershell\windows\winadmin\winadmin.psd1" -Author "Soheil.amiri" -Description "this is windows postinstallation module" -RootModule "winadmin.psm1" -ModuleVersion "0.0.1"

$($env:PSModulePath).Split(';')

winadmin-applyposttask
Import-Module C:\Users\Soheil\Cloud-networking-1\Powershell\windows\winadmin -force

Get-Command -Module winadmin