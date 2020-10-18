# Add the firewall rule

# Started here and somehow found all I need:
# https://stackoverflow.com/a/61110604/1365754

# This script needs to be run in an elevated powershell.

Import-Module -Name 'NetSecurity'

$rulename = 'WSL 2 Firewall Unlock'
$programname = 'C:\program files\vcxsrv\vcxsrv.exe'
$localport = 6000

# Get the remote ip.
$remoteip = wsl.exe /bin/bash -c "ip addr show eth0 | grep -oP '(?<=inet\s)\d+(\.\d+){3}'"
$remoteipfound = $remoteip -match '\d{1,3}\.\d{1,3}\.\d{1,3}\.\d{1,3}';
if( !$remoteipfound ){
  Write-Output "The Script Exited, the remote ip address of WSL 2 cannot be found";
  exit;
}

# Get the local ip.
$localip = wsl bash -c 'ip route | awk ''/default via /'' | cut -d'' '' -f3'
$localipfound = $localip -match '\d{1,3}\.\d{1,3}\.\d{1,3}\.\d{1,3}';
if( !$localipfound ){
  Write-Output "The Script Exited, the local ip address of WSL 2 cannot be found";
  exit;
}

# Delete the rule if it exists already.
$rulefound = Get-NetFirewallRule -DisplayName $rulename 2> $null; 
if ($rulefound) { 
  Remove-NetFireWallRule -DisplayName $rulename
} 

# Add the new rule.
New-NetFireWallRule -DisplayName $rulename -Direction Inbound -LocalAddress $localip -RemoteAddress $remoteip -Action Allow -Protocol TCP -LocalPort $localport -Program $programname

# Stop vcsxrv (if already running it needs to be restarted)
Stop-Process -Name "vcxsrv" -Force

# C:\Program` Files\VcXsrv\vcxsrv.exe :0 -multiwindow -clipboard -wgl -ac

# # Run Emacs in WSL2

# $wslip = wsl bash -c 'ip route | awk ''/default via /'' | cut -d'' '' -f3'
# # $wslip = wsl.exe /bin/bash -c 'ip route | awk ''/default via /'' | cut -d'' '' -f3'

# wsl zsh -c "export DISPLAY=$wslip`:0.0 export LIBGL_ALWAYS_INDIRECT=1 && setxkbmap -layout us && setsid emacs"