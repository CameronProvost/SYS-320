#!/bin/bash

#Parse Apache log

#Read in File

#Arguments using position
APACHE_LOG="$1"


#Check if file exists

if [[ ! -f ${APACHE_LOG}  ]]
then
	echo "File does not exist, please specify the path to a log file."
	exit 1

fi

# Looking for web scanners.
sed -e "s/\[//g" -e "s/\"//g" ${APACHE_LOG} | \
egrep -i "test|shell|echo|passwd|select|phpmyadmin|setup|admin|w00t" | \
awk ' BEGIN { format = "%-15s %-20s %-7s %-6s %-10s %s\n"
		printf format, "IP", "Date", "Method", "Status", "Size", "URI"
		printf format, "--", "----", "------", "------", "----", "---"}


{ printf format, $1, $4, $6, $9, $10, $7 }'


#Get ip address and sort

function sortips() {
	cat ${APACE_LOG} | awk '{print $1}' | sort -u | tee badIPs.txt
}

# Create iptable ruleset 

function iptableruleset() {
	if [[ -f badIPs.txt ]]
	then 
		for IP in $(cat badIPs.txt)
		do
			echo "iptables -A INPUT -s ${IP} -j DROP" | tee -a badIPS.iptables
		done
	else
		for IP in $(cat badIPs.txt)
		do
			echo "iptables -A INPUT -s ${IP} -j DROP" | tee -a badIPs.iptables
		done
	fi
}


#Call function

iptableruleset
