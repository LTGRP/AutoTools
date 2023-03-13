#!/bin/bash

clear

echo "Showing IPs with max connections"

echo ""

cd /var/log/nginx

awk '{print $1 }' access.log | sort | uniq -c | sort -nr | head -20

echo ""

echo ; read -p "Type in IP to BLOCK " IP;

echo ""

/sbin/route add $IP 127.0.0.1 -blackhole

echo ""

echo "$IP IP Blocked Forever!!"
