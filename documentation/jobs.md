# Jobs

## At and Batch

### Schedule a Command

```bash
man at
# If not installed
sudo yum install -y at
# Ensure the at daemon is running
sudo systemctl start atd
sudo systemctl enable atd
```

Schedule a job to run 5 minutes from now:

```bash
at now +5min
```

Enter an arbitrary number of commands to execute:

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

Execute an arbitrary number commands (if the system isn't busy):

```bash
batch
touch ~/batch-file.txt
```

Press `ctrl + d` to save and exit the prompt.

Confirm the command was executed:

```bash
ls -l ~/batch-file.txt
```

---

## Cron Jobs

```bash
man cron
man crontab
man 5 crontab
sudo systemctl start crond
sudo systemctl enable crond
```

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

### User Cron Job

```bash
crontab -e # Edit
# Use vim, nano, etc. to append
0 1 * * * rsync -a ~/Documents/ ~/Documents.bak
crontab -l # Display (list)
crontab -r # Remove
```

### Root Cron Job

```bash
sudoedit /etc/cron.d/backupdocs
0 1 * * * root rsync -a /home/vagrant/Documents/ /home/vagrant/Documents.bak
```

### Timely Cron Job Directories

```bash
ls -d /etc/cron.*
```

### Limiting Access

If the allow file exists (and is empty), no one is allowed.  
If the deny file exists (and is empty), no one is denied.

```bash
/etc/at.allow
/etc/cron.allow
/etc/at.deny
/etc/cron.deny
```

The allow file has priority over the deny file if the files are not empty.

### PAM Configuration Files

PAM-aware services can be found in directory: `/etc/pam.d/`

The files' syntax are:  
`module_interface` `control_flag` `module_name` `module_arguments`

Use access.conf to limit user access:

```bash
man access.conf
sudoedit /etc/security/access.conf
# Syntax: access control, username, service
# Deny ALL users access (EXCEPT root) to use cron
:ALL EXCEPT root:cron
```
