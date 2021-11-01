# Block malicous IP ranges from Gitlab NGINX logs

Shell scripts to block IP ranges which try to brute force the 
login page in Gitlab.

## Usage

Add the following line to crontab:

```
@reboot ~/gitlab_iptables_blocker/add_iptables_block.sh
@hourly ~/gitlab_iptables_blocker/add_iptables_block.sh 
@hourly ~/gitlab_iptables_blocker/update_blocked_ips.sh 
```
