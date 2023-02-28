# RHEL Packages

Most Linux distributions offer downloadable software repositories,
which are accessed via FTP or HTTP to a file server containing an
index of software packages and their metadata.

RHEL packages software as `rpm` files
and uses `yum` or `dnf` (RHEL 8+) to install them.

## RPM Queries

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

## More Query Commands

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

## Dandified (DNF) YUM

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

## System Packages

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

## Package Groups

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

## OS Upgrades

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
