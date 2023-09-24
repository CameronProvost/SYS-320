 #!/bin/bash

 #Storyline: Extract IPs from emergingthreats.net and create a firewall ruleset

 # Check to see if Emerging Threats File exists, if not download it

emergingthreatsfile=/tmp/emerging-drop.rules 

 if [ -f "${emergingthreatsfile}"]; then
	 read -p "Emerging Threats File is already downloaded, do you want to download it again? [y/n] "
	
	 if [ "${userinput}" == "y" ]; then
		 wget http://rules.emergingthreats.net/blockrules/emerging-drop.rules -O /tmp/emerging-drop.rules
	 elif [ "${userinput}" == "n" ]; then
		 echo "Emerging threats file will not be downloaded."

	else
		echo "Invaild input"
	fi

else
	 echo "Emerging Threats File is not downloaded, downloading now"
	 wget http://rules.emergingthreats.net/blockrules/emerging-drop.rules -O /tmp/emerging-drop.rules

#Parse Github File

githubthreatfile=/tmp/targetedthreats.rules

if [ -f "${githubthreatfile}"]; then
         read -p "The Guthub Targeted Threats File is already downloaded, do you want to download it again? [y/n] "

         if [ "${userinput}" == "y" ]; then
                 wget https://raw.githubusercontent.com/botherder/targetedthreats/master/targetedthreats.csv -O /tmp/targetedthreats.rules
         elif [ "${userinput}" == "n" ]; then
                 echo "Targeted Threats file will not be downloaded."

        else
                echo "Invaild input"
        fi

else
         echo "Targeted Threats File is not downloaded, downloading now"
         wget https://raw.githubusercontent.com/botherder/targetedthreats/master/targetedthreats.csv  -O /tmp/targetedthreats.rules



# Regex to extract the networks

 egrep -o '[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.0/[0-9]{1,2}' /tmp/emerging-drop.rules | sort -u | tee badIPs.txt

#Rules for Mac

 echo '
scrub-anchor "com.apple/*"
nat-anchor "com.apple/*"
dummynet-anchor "com.apple/*"
anchor "com.apple/*"
load anchor "com.apple" from "/etc/pf.anchors/com.apple"
 ' | tee pf.conf


 # Create a firewwall ruleset
 
          for eachIP in $(cat badIPs.txt)
          do
		  echo "block in from ${eachIP} to any" | tee -a pf.conf

	          echo "iptables -A INPUT -s ${eachIP} -j DROP" | tee -a badIPS.iptables

          done


 fi
