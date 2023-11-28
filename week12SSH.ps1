#Prompts the user for ip of host and user credentials for ssh connection

cls

$ip = read-host -Prompt "Please enter the ip of the ssh host to connect to"
$user = read-host -Prompt "Please enter the user you want to login to"

# Login to a remote SSH Server
New-SSHSession -ComputerName $ip -Credential (Get-Credential $user)


while ($True) { 

    # Add a prompt to run commands
    $the_cmd = read-host -Prompt "Please enter a command"

    #Run command on remote SSH Server
    (Invoke-SSHCommand -index 0 $the_cmd).Output 

}

#Set-SCPfile -Computername '192.168.4.22' -Credential (Get-Credential sys320) 
#-RemotePath '/home/sys320' -LocalFile '.tedx.jepg'