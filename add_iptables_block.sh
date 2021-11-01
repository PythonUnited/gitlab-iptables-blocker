BLOCKED_IPS=`cat ~/gitlab-iptables-blocker/blocked_ips.txt`

echo $BLOCKED_IPS

IPTABLES_LIST=`iptables -L DOCKER-USER`

while read -r line; do
    if ! echo "$IPTABLES_LIST" | grep -q $line; then
        echo "Adding $line to iptables deny rule"
        sh -c "iptables -I DOCKER-USER -s $line -j DROP -m comment --comment \"Malicious IP range\""
    fi
done <<< $BLOCKED_IPS

