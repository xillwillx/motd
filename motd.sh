#!/bin/bash
#copy this to: /etc/profile.d/motd.sh
echo Hostname: `hostname`>motd
echo Uptime: $(uptime | awk -F'( |,|:)+' '{if ($7=="min") m=$6; else {if ($7~/^day/) {d=$6;h=$8;m=$9} else {h=$6;m=$7}}} {print d+0,"days,",h+0,"hours,",m+0,"minutes."}') >>motd
InIP=`ip -4 addr show eth0 | grep -oP '(?<=inet\s)\d+(\.\d+){3}'`
ExIP="$(dig +short myip.opendns.com @resolver1.opendns.com)"
WifiIP=`ip -4 addr show wlan0 | grep -oP '(?<=inet\s)\d+(\.\d+){3}'`
[[ ! -z "$ExIP" ]] && echo External IP: "$ExIP">>motd
[[ ! -z "$InIP" ]] && echo Internal IP: "$InIP">>motd
[[ ! -z "$WifiIP" ]] && echo WIFI IP: "$WifiIP">>motd
cpu=$(</sys/class/thermal/thermal_zone1/temp)
cpu=$((cpu/1000))
echo CPU Temp: "$cpu""˚C / $(( $cpu * 9 / 5 + 32 ))˚F" >>motd
curl -s -N http://wttr.in/ | head -n 7 >>motd
echo "CPU: `LC_ALL=C top -bn1 | grep "Cpu(s)" | sed "s/.*, *\([0-9.]*\)%* id.*/\1/" | awk '{print 100 - $1}'`% RAM: `free -m | awk '/Mem:/ { printf("%3.1f%%", $3/$2*100) }'` HDD: `df -h / | awk '/\// {print $(NF-1)}'`" >>motd
cat motd
