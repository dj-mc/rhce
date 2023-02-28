# Logs

## rsyslog

- Logs into a text file
- Compatible with `sysklogd`
- Persists after machine reboot
- Can be utilized remotely

```bash
sudo systemctl start rsyslog
sudo systemctl enable rsyslog

man 3 syslog
man 8 sysklogd

# Observe how logs are structured
# and where they're located.
less -N /etc/rsyslog.conf
```

Syntax:

`authpriv.crit` `/var/log/secure`

Selector field: `authpriv.crit`  
Facility: `authpriv` Priority: `crit`  
Action field: `/var/log/secure`

Log everything from info, excluding facilities listed as none:  
`*.info;mail.none;authpriv.none;cron.none` `/var/log/messages`

Read system logs from `/var/log/messages`:

```bash
sudo cat /var/log/messages
# Read only the last 15 logs
sudo cat /var/log/messages | tail --lines=15
# Follow the last few written logs
sudo tail -f /var/log/messages

# Invert match with egrep's -v to exclude any matched regex
sudo egrep -v 'systemd|NetworkManager' /var/log/messages
```

```bash
ls /etc/cron.daily
logger "GNU is not Unix"
```

## journald

- From the `systemd` software suite
- Does not persist after machine reboot
- Logs are stored in directory: /var/run/
- And are binary and stored in machine RAM
- And therefore very fast to utilize
- Size is limited to available machine RAM

See if any temporary files have been written by your system:

```bash
sudo ls -lS /var/run/
```

Access all journal logs:

```bash
sudo journalctl
# Follow the last few written logs
sudo journalctl -f

# Write the head or tail from all journal logs
sudo journalctl | head --lines=100 > ~/Documents/journal-first-100.log
sudo journalctl | tail --lines=100 > ~/Documents/journal-last-100.log
# Specify desired logs
sudo journalctl /sbin/crond
```

Persist journal logs across reboots:

```bash
sudo mkdir -p /var/log/journal
sudo systemctl restart systemd-journald
ls -l /var/log/journal/
```

```bash
# Logs written since yesterday
sudo journalctl --since yesterday
# Logs written from the boot process
sudo journalctl -b -l
```

```bash
# --pager-end, --follow, --catalog
sudo journalctl -efx > ~/Documents/journalctl-efx.log
```
