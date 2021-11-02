# Block malicous IP ranges from Gitlab NGINX logs

Shell scripts to block IP ranges which try to brute force the 
login page in Gitlab CE. 

## Prerequisites

Install `ipcalc`. This program is used to found out the
IP network so the entire IP range for a given IP address
can be blocked in iptables.

The scripts expect to live in `~/gitlab-iptables-blocker`.

## Usage

Add the following lines to crontab:

```
@reboot cd ~/gitlab-iptables-blocker && ./add_iptables_block.sh
@hourly cd ~/gitlab-iptables-blocker && ./add_iptables_block.sh 
@hourly cd ~/gitlab-iptables-blocker && ./update_blocked_ips.sh 
```

Blocked IPs are stored in `~/gitlab-iptables-blocker/blocked_ips`
