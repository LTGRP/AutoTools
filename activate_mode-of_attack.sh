#!/bin/bash

clear

echo "Showing available interfaces"

echo ""

ifconfig | grep :

echo ""

echo ; read -p "Which interfaces do you want to configure?" INTERFACE;

echo ""

rm -rf /etc/pf.conf

touch /etc/pf.conf

echo '

#MODE OF ATTACK ACTIVATED
# the external network interface to the internet
ext_if="'$INTERFACE'"
# port on which sshd is running
ssh_port = "3333"
# allowed inbound ports (services hosted by this machine)
inbound_tcp_services = "{3333}"
block in all
pass out all keep state' >> /etc/pf.conf

service pf reload

echo ""

echo "MODE OF ATTACK ACTIVATED"
