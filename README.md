# Block malicous IP ranges from Gitlab NGINX logs

Shell scripts to block IP ranges which try to brute force the 
login page in Gitlab.

## Usage

Add the following line to crontab:

```
@reboot cd ~/gitlab-iptables-blocker && ./add_iptables_block.sh
@hourly cd ~/gitlab-iptables-blocker && ./add_iptables_block.sh 
@hourly cd ~/gitlab-iptables-blocker && ./update_blocked_ips.sh 
```
