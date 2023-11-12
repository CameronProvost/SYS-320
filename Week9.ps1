#Story
#Display DHCP Server's IP address
Get-WmiObject Win32_NetworkAdapterConfiguration | Where-Object { $_.DHCPEnabled -eq $true } | Select-Object -ExpandProperty DHCPServer

#Display DNS Server's IP
Get-WmiObject Win32_NetworkAdapterConfiguration | Where-Object { $_.DNSDomain -ne $null } | Select-Object -ExpandProperty DNSServerSearchOrder

#Saved Files Directory
$SaveDir = "C:\Users\Champuser\Desktop\"

#Get Running Processes
Get-Process | Select-Object ProcessName, Path | Export-Csv -Path "$SaveDir\RunningProcesses.csv" 

#Get Running Services
Get-Service | where { $_.Status -eq "Running" } | Select-Object DsiplayName, Status | Export-Csv -Path "$SaveDir\RunningServices.csv" 

#Open Calculator
Start-Process calc.exe
sleep 5

#Stop Calculator
Stop-Process -Name win32calc
