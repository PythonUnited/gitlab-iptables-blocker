BLOCKED_IPS_FILE="blocked_ips.txt"
BLOCKED_IPS=`cat $BLOCKED_IPS_FILE`

IPTABLES_LIST=`iptables -L DOCKER-USER`

while read -r line; do
    if ! echo "$IPTABLES_LIST" | grep -q $line; then
        echo "Adding $line to iptables deny rule"
        iptables -I DOCKER-USER -s $line -j DROP -m comment --comment "Malicious IP range"
    fi
done <<< $BLOCKED_IPS

