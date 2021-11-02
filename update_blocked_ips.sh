#!/bin/bash

pattern="/users/sign_in"
grep_path="/var/opt/gitlab/nginx/logs/gitlab_access.log*"
grep_cmd="/usr/bin/zgrep $pattern $grep_path | grep POST | grep -v 302| grep 'python-requests'"

container_id=`docker ps |grep gitlab-ce |awk '{print $1}'`
nginx_logs=`docker exec $container_id sh -c "$grep_cmd"`

bad_ips=`echo "$nginx_logs" | awk '{ print $1 }' | awk -F: '{ print $2 }'`
bad_ip_ranges=$(
    while read -r line; do
        echo `ipcalc $line | grep Network | awk '{print $2}'`
    done <<< "$bad_ips"
)
uniq_bad_ip_ranges=`echo "$bad_ip_ranges" | sort | uniq`

blocked_ips_file=~/gitlab-iptables-blocker/blocked_ips.txt
touch $blocked_ips_file
blocked_ips=`cat $blocked_ips_file`

while read -r line; do
    if [ ! -z "$uniq_bad_ip_ranges" ] && ! echo "$blocked_ips" | grep -q $line; then
        echo "Adding $line to blocked_ips.txt" 
        echo "$line" >> "$blocked_ips_file"
    fi
done <<< $uniq_bad_ip_ranges
