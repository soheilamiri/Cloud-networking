
#define destination folder to save config 
$destinationDirectory = "E:\Config-file\server-config\NATVPN\"

#add your SSH public key to remote server
scp -P 5555 USER@172.16.64.254:/etc/rc.local $destinationDirectory
scp -P 5555 USER@172.16.64.254:/etc/netplan/00-installer-config.yaml $destinationDirectory
scp -P 5555 USER@172.16.64.254:/etc/rules.v4 $destinationDirectory



# Get today's date in the desired format (e.g., YYYYMMDD)
$todayDate = Get-Date -Format "yyyyMMdd"
New-Item -Type Directory -path $destinationDirectory -Name $todaydate
Move-Item -path "$destinationDirectory\*.*" -Destination $destinationDirectory\$todaydate