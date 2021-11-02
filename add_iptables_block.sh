#!/bin/bash
iptables_path=/usr/sbin/iptables
blocked_ips=`cat ~/gitlab-iptables-blocker/blocked_ips.txt`
iptables_list=`$iptables_path -L DOCKER-USER`

while read -r line; do
    if ! echo "$iptables_list" | grep -q $line; then
        echo "Adding $line to iptables deny rule"
        sh -c "$iptables_path -I DOCKER-USER -s $line -j DROP -m comment --comment \"Malicious IP range\""
    fi
done <<< $blocked_ips

