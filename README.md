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

---

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

Try out these commands to get technical information on the system you're running.

```bash
df
hostnamectl
uname -r
top

which ls
whereis ls
file /usr/bin/ls
stat /usr/bin/ls

ls -l ~
lsattr ~
lscpu
lsblk -a
lsusb -v
lspci -t
sudo lshw
sudo lsof -i -P -n

nl /etc/passwd
cat -n /etc/passwd
more /etc/passwd
less /etc/passwd

sudo dmesg | less
sudo dmidecode -t bios
sudo dmidecode -t memory
sudo dmidecode -t processor
sudo dmidecode -t system
sudo hdparm /dev/sda1
sudo fdisk -l
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

## Permissions

| permission | owner | group | public |
| ---------- | ----- | ----- | ------ |
| read       | 400   | 40    | 4      |
| write      | 200   | 20    | 2      |
| execute    | 100   | 10    | 1      |

`(d-w--w--w-)` a directory with permission 200 + 20 + 2 = 222

### SSH Permissions

.ssh directory: 700 `(drwx------)`
public key file (.pub): 644 `(-rw-r--r--)`
private key file (id_rsa): 600 `(-rw-------)`
home directory: at most 755 `(drwxr-xr-x)`

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

inet 192.168.33.14/24
192.168.33.255

inet 192.168.33.15/24
192.168.33.255
