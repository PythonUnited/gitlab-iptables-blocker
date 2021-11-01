#!/bin/bash

PATTERN="/users/sign_in"
GREP_PATH="/var/opt/gitlab/nginx/logs/gitlab_access.log*"
GREP_CMD="/usr/bin/zgrep $PATTERN $GREP_PATH | grep POST | grep -v 302| grep 'python-requests'"

CONTAINER_ID=`docker ps |grep gitlab-ce |awk '{print $1}'`
NGINX_LOGS=`docker exec -it $CONTAINER_ID sh -c "$GREP_CMD"`

BAD_IPS=`echo "$NGINX_LOGS" | awk '{ print $1 }' | awk -F: '{ print $2 }'`
BAD_IP_RANGES=$(
while read -r line; do
    echo `ipcalc $line | grep Network | awk '{print $2}'`
done <<< "$BAD_IPS"
)
UNIQ_BAD_IP_RANGES=`echo "$BAD_IP_RANGES" | sort | uniq`


BLOCKED_IPS_FILE=`cat blocked_ips.txt`
while read -r line; do
    if ! echo "$BLOCKED_IPS_FILE" | grep -q $line; then
        echo "Adding $line to blocked_ips.txt" 
        echo "$line" >> blocked_ips.txt
    fi
done <<< $UNIQ_BAD_IP_RANGES
