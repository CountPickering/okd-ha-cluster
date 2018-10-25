## Not needed as we are reverting and will loose any changes 
## Guest Shutdown VMs that start with ose
#Shutdown-VMGuest -VM ose* -Confirm:false

#Connecto to vcsa1 
Connect-VIServer -Server vcsa1.its.local

#Forech each vm that starts with ose, set the snapshot to Snapshot #3
$vms = Get-VM ose* | ForEach-Object {$_.Name}
$vms | %{
	Set-VM -VM $_ -Snapshot (Get-Snapshot -VM $_ -Name "Snapshot #3") -Confirm:$False
}

#Start All the vms that start with ose
Start-VM -VM ose*
