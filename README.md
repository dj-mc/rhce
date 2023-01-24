# rhce

Red Hat Certified Engineer (RHCE)

---

Red Hat Enterprise Linux (RHEL) notes on
system administration and infrastructure development.

Most commands should also work on Cent OS and Rocky Linux.

---

## Services

```bash
# List all (-a) known units
# whose type (-t) is service
systemctl list-units -at service

# List only unit services
# whose state is running
systemctl list-units -t service --state running

# List the is-enabled state of installed unit files
systemctl list-unit-files -at service

# Display service data
# rsyslog is a system logging service
systemctl cat rsyslog

# Get the status of a service
systemctl status rsyslog
```

```bash
systemctl cat atd

# Stop a service
sudo systemctl stop atd
systemctl status atd

# Start a service
sudo systemctl start atd
systemctl status atd

# Restart (stop/start) a service
sudo systemctl restart atd

# Check if a service is-active
systemctl is-active atd

# Prevent a service from starting
sudo systemctl mask atd
# Failed to start atd.service: Unit is masked
sudo systemctl start atd

# Just unmask to reverse the mask
sudo systemctl unmask atd
sudo systemctl start atd

# Disable a service from starting
sudo systemctl disable atd
systemctl is-enabled atd

# Re-enable a service to start
sudo systemctl enable atd
systemctl is-enabled atd
```

---

## Networking

### IP address

### Default gateway

### Network mask

### Hostname

- edit `/etc/hostname`
- hostnamectl

### Name resolution

- edit `/etc/hosts`
- dynamic resolution using DNS
- add DNS servers to `/etc/resolv.conf`
- static nameserver config
- use Network Manager

### Network device naming

`en`: ethernet  
`wl`: wireless LAN (WLAN)  
`ww`: wireless wide area network (WWAN)

Use firmware or BIOS information.

- onboard devices
- PCI express hotplug devices

Use devices found physically.

- PCI card slot
- PCI express slot

### Tools

```bash
ip
nmcli
nmtui
nm-connection-editor
```

Or use GNOME's network GUI.

```bash
ip addr
sudo nmtui
nm-connection-editor
```

Or manually create or modify `ifcfg-eth0`:  
`sudoedit /etc/sysconfig/network-scripts/ifcfg-eth0`

---

## Date and time

### System time

```bash
timedatectl
timedatectl list-timezones
timedatectl list-timezones | grep America
# Manually set the time
timedatectl set-time 22:22:22
# Manually set the date and time
timedatectl set-time "2007-05-13 22:22:22"
# Set the timezone location
timedatectl set-timezone America/Chicago
# Enable network time synchronization
timedatectl set-ntp true
```

### Schedule a command

```bash
man at
# If not installed
sudo yum install -y at
# Ensure the at daemon is running
sudo systemctl start atd
sudo systemctl enable atd
```

### Using at and batch

Schedule a job to run 5 minutes from now.

```bash
at now +5min
```

Enter an arbitrary number of commands to execute.

```bash
mkdir ~/Documents.bak
rsync -a ~/Documents/ ~/Documents.bak
```

Press `ctrl + d` to save and exit the prompt.

```bash
atq
# Concat (-c) the job to stdout
at -c <jobid>
# Remove the job
atrm <jobid>
atq
```

Execute an arbitrary number commands (if the system isn't busy).

```bash
batch
```

```bash
touch ~/batchfile.txt
```

Press `ctrl + d` to save and exit the prompt.

Confirm the command was executed.

```bash
ls -l ~/batchfile.txt
```

---

## Cron jobs

User cron jobs are stored in directory:  
`/var/spool/cron/<user>`  
User cron jobs are specific to each user, and can be managed by them.  

System cron jobs are managed by the root user: `/etc/cron.d`

Run every minute of the 23rd hour (11pm) every Sunday (0th day of the week):  
`* 23 * * 0 /home/vagrant/bin/my_script.sh`

Run every 10th minute of 11pm every Monday:  
`*/10 23 * * 1 /home/vagrant/bin/my_script.sh`

Run 45 minutes after 11pm every Tuesday:  
`45 23 * * 2 /home/vagrant/bin/my_script.sh`

Run on minutes 15, 30, and 45 of 11pm every Wednesday:  
`15,30,45 23 * * 3 /home/vagrant/bin/my_script.sh`

Run at 11:45pm every day of every weekend, from March to May:  
`45 23 * 3-5 6,0 /home/vagrant/bin/my_script.sh`

Run every odd minute:  
`1-59/2 * * * * /home/vagrant/bin/my_script.sh`

```bash
man cron
man crontab
man 5 crontab
sudo systemctl start crond
sudo systemctl enable crond
```

### User cron job

```bash
crontab -e # Edit
# Use vim, nano, etc. to append
0 1 * * * rsync -a ~/Documents/ ~/Documents.bak
crontab -l # Display
crontab -r # Remove
```

### Root cron job

```bash
sudoedit /etc/cron.d/backupdocs
0 1 * * * root rsync -a /home/vagrant/Documents/ /home/vagrant/Documents.bak
```

### Timely cron job directories

```bash
ls -d /etc/cron.*
```

### Limit access

If the allow file exists (and is empty), no one is allowed.  
If the deny file exists (and is empty), no one is denied.

```bash
/etc/at.allow
/etc/cron.allow
/etc/at.deny
/etc/cron.deny
```

The allow file has priority over the deny file if the files are not empty.

### PAM configuration files

```bash
man access.conf
sudoedit /etc/security/access.conf
# Syntax: access control, username, service
# Deny ALL users access (EXCEPT root) to use cron
:ALL EXCEPT root:cron
```
