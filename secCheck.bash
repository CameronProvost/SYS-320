#!/bin/bash

#Script to perform loacl secuirty checks

function checks() {
	
	if [[ $2 != $3 ]]
	then
		echo "The $1 is not compliant. The current policy should be: $2, the current value is: $3"
		echo "The remediation for this is: $4"

	else
		echo "The $1 is compliant. The current policy is: $3."

	fi
}



#Check that ip forwarding is disabled

ipforwarding=$(sysctl net.ipv4.ip_forward | awk '{print $3}')
checks "ip forwarding" "0" "${ipforwarding}" "Set net.ipv4.ip_forward = 0 in /etc/sysctl.conf."

#Checks that ICMP redirects are not accepted

ICMPredirects=$(sysctl net.ipv4.conf.all.secure_redirects | awk '{print $3}')
checks "ICMP redirects" "0" "${ICMPredirects}" "Set  net.ipv4.conf.all.secure_redirects = 0 in /etc/sysctl.conf"


#Checks /etc/crontab permissions

crontabperms=$(stat -c %a /etc/crontab)
checks "Crontab permissions" "644" "${crontabperms}" "chown root:root /etc/crontab and chmod og-rwx /etc/crontab"

#Checks /etc/cron.hourly

cronhourly=$(stat -c %a /etc/cron.hourly)
checks "Cron.hourly permissions" "755" "${cronhourly}" "chown root:root /etc/cron.houly and chmod og-rwx /etc/cron.hourly"


#Checks /etc/cron.daily

crondaily=$(stat -c %a /etc/cron.daily)
checks "Cron.daily permissions" "755" "${crondaily}" "chown root:root /etc/cron.daily and chmod og-rwx /etc/crondaily"

#Checks /etc/cron.weekly

cronweekly=$(stat -c %a /etc/cron.weekly)
checks "Cron.weekly permissions" "755" "${cronweekly}" "chown root:root /etc/cron.weekly and chmod og-rwx /etc/cron.weekly"

#Checks /etc/cron.monthly

cronmonthly=$(stat -c %a /etc/cron.monthly)
checks "Cron.monthly permissions" "755" "${cronmonthly}" "chown root:root /etc/cron.monthly and chmod og-rwx /etc/cron.monthly"

#Checks /etc/passwd permissions

passpolicy=$(stat -c %a /etc/passwd)
checks "passwd policy" "644" "${passpolicy}" "chown root:root /etc/passwd and chmod 644 /etc/passwd"

#Checks /etc/shadow

shadowpolicy=$(stat -c %a /etc/shadow)
checks "shadow policy" "640" "${shadowpolicy}" "chown root:shadow /etc/shadow"

#Checks /etc/group
grouppolicy=$(stat -c %a /etc/group)
checks "group policy" "644" "${grouppolicy}" "chown root:root /etc/group"

#Checks /etc/gshadow

gshadowpolicy=$(stat -c %a /etc/gshadow)
checks " gshadow policy" "640" "${gshadowpolicy}" "chown root:shadow /etc/gshadow"

#Checks /etc/passwd-
passwdpolicy=$(stat -c %a /etc/passwd)
checks "passwd- policy" "644" "${passwdpolicy}" "chown root:root /etc/passwd-"

#Checks /etc/shadow-
shdo=$(stat -c %a /etc/shadow-)
checks "shadow- policy" "640" "${shdo}" "chown root:shadow /etc/shadow-"

#Checks /etc/group-
group=$(stat -c %a /etc/group-)
checks "group- policy" "644" "${group}" "chown root:root /etc/group-"

#Checks /etc/gshadow-"
gshadow=$(stat -c %a /etc/gshadow-)
checks "gshadow- policy" "640" "${gshadow}" "chown root:shadow /etc/gshadow-"

#Checks if root is only UID 0
UID0Users=$(cat /etc/passwd | awk -F: '($3 == 0) {print $1}')
checks "users with UID 0" "root" "{$UID0Users}" "Remove users other then root with UID of 0"
