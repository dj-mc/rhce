# rhce

This repo is being built for:

Red Hat Certified System Administrator (RHCSA)  
Red Hat Certified Engineer (RHCE)

---

Red Hat Enterprise Linux (RHEL) notes on
automation, system administration, and infrastructure.

This repo uses Vagrant to quickly set up a RHEL-related VM.

---

## GUI

```bash
sudo dnf groupinstall workstation
sudo systemctl set-default graphical.target
sudo systemctl isolate graphical
```

## Manuals

Man pages are located in directory: `/usr/share/man`.

```bash
man man
man man-pages
zcat /usr/share/man/man1/man.1.gz

# Section 1 of the intro pages
man 1 intro
# All sections of the intro pages
man -a intro

# Find pages related to a referenced command
man -f cron
whatis -r cron

# Find pages related to a regular expression
man -k cron
apropos -r cron

# Find help using --help
ls --help

# Find help on shell built-ins
help
help cd

# Find extensive information
# These pages include hyperlinks to other info pages
info
info bash

# Learn something new
man perl
apropos perl
info perl
```

---

## System Information

```bash
hostnamectl
file /usr/bin/ls
which ls
```

---

## Text Editors

```bash
nano ~/Documents/new-file.txt
# Input some text
# then enter Ctrl+O to write it to file.
# Enter Ctrl+X to quit

vim ~/Documents/new-file.txt
# Use hjkl to navigate the cursor
# Press i to input some text at the cursor
# Press ESC
# Enter :w to write it to the file
# Enter :q to quit or :q! to force quit
# Or combine them as :wq

vimtutor
# Enter :quit to quit or :quit! to force quit

# Open vim in a directory
vim ~/Documents
# Enter :tabe new-file.txt
# to open a file as a new tab.
# Press Ctrl+Alt+PgUp/PgDn to navigate
# Enter :quit or :q to exit a tab
```

---

## Files and Directories

Try out these commands.  
Use `man` or `info` to see what they do.

```bash
mkdir ~/dir1
mkdir -p ~/{dir1,dir2,dir3}
mkdir -p ~/dir3
vim ~/dir3/my-file.txt
touch ~/dir3/another-file.txt
ls -d ~/dir?
find ~/dir?
```

```bash
# Move a file: source to destination
# -b -n -u: backup, no clobber, update
mv -b -n -u ~/dir3/my-file.txt ~/my-file.txt

# Copy a file: source to destination
cp -pf --verbose ~/my-file.txt ~/Documents/my-file.txt
cp -R ~/dir3 ~/dir4
```

Want to know what `-pf`, `-R`, or `--verbose` does for `cp`?

1. `man cp`
2. Type `/` and then `-p`, `-f`, `-R`, or `--verbose` to search
3. Press `enter` and then `n` or `shift+n` to navigate

You can do this for any command, flag, option, etc.
to find what you need to know.

```bash
# Try out tree
sudo yum install -y tree

# Ensure you're in your home directory
# for the rest of this section.

cd ~

tree
tree | grep my-file.txt
man tree

# Brace expansion
mkdir dir_{a,b,c}
touch file_{1,2,3,4}.txt
tree

# File globbing
touch file{a,b,c,d,e,f,g}.txt
ls file[ceg].txt
ls file{c,e,g}.txt
ls file?.txt
ls file+(c|e|g).txt

# Interactively remove files
rm -i file*
# Recursively remove multiple directories
rm -r dir_a dir_c dir_b
tree
```

Hard links:

- Use practically zero space on disk
- Cannot link to directories or across partitions
- Will not break when its target is deleted
- Use tools like `ls -l` or `stat` to identify inodes

```bash
# More on inodes
ls -idl ~
df -i /dev/sda1
info inode
```

Symbolic (soft) links:

- Does use some space on disk
- Can link to directories or across partitions
- Will break when its target is deleted
- Explicitly easier to identify with `ls -l`

```bash
touch link-me.txt
ln link-me.txt hard-linked.txt
ls -l

# Notice the inode value
stat link-me.txt
stat hard-linked.txt

ln -s link-me.txt soft-linked.txt
ls -l

# Delete the links' target
rm link-me.txt
ls -l
```

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

- Clean up
- Add more info

### IP Address

todo

### Default Gateway

todo

### Network Mask

todo

### Hostname

- Edit `/etc/hostname`
- `hostnamectl`

### Name Resolution

- Edit `/etc/hosts`
- Dynamic resolution using DNS
- Add DNS servers to `/etc/resolv.conf`
- Static nameserver config
- Use Network Manager

### Network Device Naming

- `en`: ethernet
- `wl`: wireless LAN (WLAN)
- `ww`: wireless wide area network (WWAN)

Use firmware or BIOS information:

- Onboard devices
- PCI express hotplug devices

Use devices found physically:

- PCI card slot
- PCI express slot

### Tools

- ip
- nmcli
- nmtui
- nm-connection-editor

Or use GNOME's network GUI:

```bash
ip addr
sudo nmtui
nm-connection-editor
```

Or manually create or modify `ifcfg-eth0`:  
`sudoedit /etc/sysconfig/network-scripts/ifcfg-eth0`

---

## Date and Time

### System Time

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

---

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

---

## Stdin/Stdout/Stderr and Redirection

A command piped to another command.

command ---> stdout | stdin ---> command

Redirect to the filesystem instead.

command ---> stdout ---> filesystem

```bash
# Overwrite
ls > /home/ls-out.txt
# Append to end
ls >> /home/ls-out.txt

# Redirect only stderr
ls 2> /home/ls-out.err
ls 2>> /home/ls-out.err

# Redirect both stdout and stderr
ls &> /home/ls-out-all.txt
ls &>> /home/ls-out-all.txt
```

```bash
# Redirect ls-out.txt to sort,
# then redirect the sorted text to sorted.txt.
sort < /home/ls-out.txt > /home/sorted.txt
```

Split stdout with tee to both a file and the screen:

```bash
# Overwrite
ls | tee ls-out.txt
# Append to end
ls | tee -a ls-out.txt
```

```bash
find /etc | sort | tee etc-sort.txt | wc -l
# Redirect find's stderr to a file
find /etc 2> etc-err.txt | sort | tee etc-sort.txt | wc -l
# Redirect both stdout/err to the bottomless pit
find /etc &> /dev/null
```

---

## Grep and Regex

```bash
find / -name '*.txt'
# Redirect permission errors to a file
find / -name '*.txt' 2> find-text-files.err

find / -name '*.txt' | grep cron
# Redirect permission errors to a file
find / -name '*.txt' 2> find-grep.err | grep cron

# Invert grep, finding non-blank lines in a file
grep -v '^$' ./find-text-files.txt

# Use grep and wc to count non-blank lines in this README.md
grep -v '^$' ./README.md | wc -l
```

Extended regex works with `awk`, `egrep`, `sed -r`, and `bash [[ =~ ]]`.

```bash
grep '^http.*tcp.*service$' /etc/services
egrep '^http.*(tcp|udp).*service$' /etc/services
```

```bash
# Search for text inside of all files in the current directory
grep -rnw . -e 'sql' --exclude-dir={venv,__pypackages__,node_modules,build,dist*}
egrep -rnw . -e 'head|tail'
```

---

## Tape Archiver

a.k.a. `tar`.

```bash
# --xattrs preserves extended attributes, like
# access control lists and SELinux security context.
# -cvpf: create, verbose, permissions, filename
sudo tar --xattrs -cvpf etc.tar /etc
```

Compression algorithms using `tar`:

```bash
sudo tar --xattrs --gzip -cvpf etc.tar.gz /etc
sudo tar --xattrs --bzip2 -cvpf etc.tar.bz2 /etc
sudo tar --xattrs --xz -cvpf etc.tar.xz /etc
```

List what's compressed in the archive:

```bash
tar --gzip -tf etc.tar.gz
tar --bzip2 -tf etc.tar.bz2
tar --xz -tf etc.tar.xz
```

Extract all files from the archive:

```bash
sudo tar --xattrs -xvpf etc.tar
# Or specify an output directory
sudo tar --xattrs -xvpf etc.tar -C /home/vagrant/Downloads/
```

Compress `/etc/services` without `tar`:

```bash
# Copy it
cp /etc/services .

# Using gzip
gzip services
gunzip services.gz

# Using bzip2
bzip2 services
bunzip2 services.bz2

# Using xz
xz services
unxz services.xz

# Using zip (Windows-compatible)
zip services.zip services
unzip services.zip
```

---

## Logs

### rsyslog

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

### journald

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

---

## RHEL Packages

Most Linux distributions offer downloadable software repositories,
which are accessed via FTP or HTTP to a file server containing an
index of software packages and their metadata.

RHEL packages software as `rpm` files
and uses `yum` or `dnf` (RHEL 8+) to install them.

### RPM Queries

- Reads a list of dependencies
- Does not maintain a list of available software
- Uses FTP or HTTP to download packages

```bash
man rpm

rpm -qa
# Query and sort all installed packages
rpm -qa | sort
rpm -qa Group="System Environment/Shells"
rpm -qa --last

# Query package information
rpm -qi bash

# Query package config files
rpm -qc yum
# Query package documentation pages
rpm -qd yum
# Query (list) the package's installed files
rpm -ql yum

# Get the package which owns the queried file
rpm -qf /bin/bash
# Get the documentation of a queried file
rpm -qdf /bin/bash

rpm -q --requires bash
rpm -q --changelog bash
rpm -q --provides bash
```

```bash
mkdir ~/Downloads/my-pkgs
# Download but don't install the a package
sudo yum install --downloadonly --downloaddir=/home/vagrant/Downloads/my-pkgs httpd
ls -l ~/Downloads/my-pkgs/

# Get information on the downloaded package
rpm -qip ~/Downloads/my-pkgs/httpd-2.4.37-51.module+el8.7.0+1059+126e9251.x86_64.rpm
rpm -qlp ~/Downloads/my-pkgs/httpd-2.4.37-51.module+el8.7.0+1059+126e9251.x86_64.rpm
```

### More Query Commands

```bash
rpm --querytags
rpm -qa --queryformat "%{NAME} %{VERSION}\n" | sort
rpm -qa --qf "%{NAME} %{VERSION}\n" | sort
rpm -qa --qf "%-30{NAME} %-10{VERSION}\n" | sort

rpm -ql bash | wc -l

rpm -q --qf "%{FILENAMES}\n" bash
rpm -q --qf "[%{FILENAMES}\n]" bash

rpm -q --qf "[%{FILENAMES} %{FILESIZES}\n]" bash
rpm -q --qf "[%-50{FILENAMES} %{FILESIZES}\n]" bash

rpm -q --qf "%{NAME} %{INSTALLTIME}\n" bash
rpm -q --qf "%{NAME} %{INSTALLTIME:date}\n" bash

rpm -q --qf "[%{FILEMODES} %{FILENAMES}\n]" bash
rpm -q --qf "[%{FILEMODES:perms} %{FILENAMES}\n]" bash
```

```bash
mkdir ~/Downloads/my-pkgs
sudo yum install --downloadonly --downloaddir=/home/vagrant/Downloads/my-pkgs httpd
ls -l ~/Downloads/my-pkgs/
rpm -qip ~/Downloads/my-pkgs/httpd-2.4.37-51.module+el8.7.0+1059+126e9251.x86_64.rpm
```

### Dandified (DNF) YUM

- yum was created for Yellow Dog Linux
- yum was overhauled and renamed to dnf
- Client maintains a local list of available software
- Software repositories contain rpm packages
- Resolves dependencies required of packages
- Can install package groups, containing many related packages
- All packages in a group can be installed or removed at once
- Might contain optional packages for additional features

```bash
# List all available versions
dnf --showduplicates list xfsprogs
```

Search available packages based on:

- Name: package name
- Version: package version
- Release: release version
- Architecture: hardware architecture
- Epoch: fine-grain control based on epoch time
  - Also allows upgrading to lower versions

Different combinations you can try:

- name
- name.arch
- name-ver
- name-ver-rel
- name-ver-rel.arch
- name-epoch:ver-rel.arch

Examples:

```bash
dnf --showduplicates list xfsprogs
dnf --showduplicates list xfsprogs.x86_64
dnf --showduplicates list xfsprogs-5.0.0
dnf --showduplicates list xfsprogs-5.0.0-10.el8
dnf --showduplicates list xfsprogs-5.0.0-10.el8.i686
```

### System Packages

```bash
dnf list
dnf list --installed
dnf list --all
dnf --showduplicates list --all
# Green is an installed package
# and (dark) blue is an available update to it.

# List packages that can be updated
dnf list --updates
# List packages available for installation
dnf list --available
# List packages that have been replaced
dnf list --obsolete

dnf info dnf
dnf info --updates
dnf info --obsoletes
dnf deplist dnf
```

```bash
dnf search vim
dnf search --all vim
dnf list --all vi*

dnf origin vim
dnf provides vim
dnf list vim

sudo dnf install -y tree
sudo dnf install -y epel-release
sudo dnf reinstall vim
sudo dnf reinstall vim --skip-broken

dnf list --updates
sudo dnf upgrade gcc
sudo dnf remove gcc # Don't actually remove gcc
# Automatically remove unnecessary packages
sudo dnf autoremove
```

### Package Groups

```bash
# Groups of related packages
dnf group list
# Not all groups are displayed by default
dnf group list hidden
dnf group info
dnf group info "Development Tools"

dnf group list ids
sudo dnf install @security-tools
sudo dnf group upgrade security-tools
sudo dnf group remove security-tools
```

### OS Upgrades

```bash
# Upgrade a package
# List all packages that can be updated
# Similar to list --updates, but check-update is non-interactive
# and returns a status code. Preferred in scripts.
dnf check-update
dnf list --obsoletes
sudo dnf upgrade grub2-tools
```

```bash
sudo dnf upgrade # Upgrade all packages
# Upgrade everything except the kernel
sudo dnf upgrade -x kernel*

# Permanently hold back specified packages
sudo dnf install python3-dnf-plugin-versionlock
dnf --showduplicates list kernel

# Lock the kernel to a specific version
sudo dnf versionlock add kernel-4.18.0-425.3.1.el8
dnf versionlock list

# Clear a specified versionlock
sudo dnf versionlock delete kernel-0:4.18.0-425.3.1.el8.*
sudo dnf versionlock clear # Or all of them

# Upgrade all security-related packages
sudo dnf upgrade --security
```

- Unmodified configs are overwritten
- Modified configs are saved as .rpmsave or .rpmorig
- Modified configs tagged with `noreplace` are saved as .rpmnew

---

## The Kernel

### Manage the Kernel

```bash
# Get changelogs
dnf changelog kernel
dnf changelog --upgrades
dnf changelog --upgrades | grep "kernel"
```

```bash
dnf list kernel
# 4.18.0-425.3.1.el8
# [version].[revision].[patch]-[release].[enterprise linux 8]

# Installed kernels
ls -l /boot
ls -l /boot/*
# Version of currently running kernel
uname -r

# Bootloader files for UEFI firmware
sudo ls -l /boot/efi/EFI
# Bootloader files for BIOS firmware
sudo ls -l /boot/grub2

sudo cat /boot/grub2/grub.cfg
# Do not edit these files,
# because any changes will be overwritten
# if the kernel is updated.

# Edit this file instead
cat /etc/default/grub
# Then update the bootloader
sudo grub2-mkconfig

# Available kernel upgrades
dnf list --available kernel

# Download and install the new kernel
sudo dnf upgrade kernel

# Remove all but the last two kernels
sudo dnf remove $(dnf repoquery --installonly --latest-limit=-2 -q)

# Set the kernel, 0 being the latest
sudo grub2-set-default 1
sudo grub2-mkconfig
```

### Kernel Modules

```bash
lsmod # Status of kernel modules
# Inject current kernel to path with uname -r
ls /lib/modules/$(uname -r)/kernel

# Get more info on a kernel module
modinfo dm_mirror

# Unload a kernel module with -r
sudo modprobe -vr dm_mirror
# Load a kernel module with -v
sudo modprobe -v dm_mirror

# Load dm_mirror upon boot
sudoedit /etc/modules-load.d/dm_mirror.conf
# Insert the following text: dm_mirror

# Blacklist a kernel module
sudoedit /etc/modprobe.d/ctxfi.conf
# Insert the following text: blacklist snd-ctxfi

# You probably don't need to blacklist snd-ctxfi
sudo rm /etc/modprobe.d/ctxfi.conf

# Required kernel modules
sudo depmod -v
```

---

## RHEL-Only Configuration

Install Ansible as a control node on RHEL.

```bash
# Enable the repo for Ansible on RHEL
sudo subscription-manager repos --list | grep ansible
sudo subscription-manager repos --enable ansible-<current version>

sudo yum install -y dnf-plugins-core
sudo yum config-manager --disable epel epel-modular
sudo yum repolist
sudo yum install -y ansible
```

### Non-RHEL Configuration (CentOS/Rocky)

Only one system should have Ansible installed.  
I have it installed on the `rocky1` VM created via Vagrant. However, it can also
be installed on the same bare-metal machine that's running Vagrant.  
I wrote a guide on setting up Vagrant + Ansible on Ubuntu [here](https://github.com/dj-mc/ansi).

Install Ansible as a control node on CentOS or Rocky.

```bash
sudo yum install -y epel-release
sudo yum install -y ansible
```

Confirm `ansible` is available to your system.  
`ansible-playbook` is a symbolic link to Ansible.

```bash
which ansible
file $(which ansible)
file $(which ansible-playbook)
ansible --version
```
