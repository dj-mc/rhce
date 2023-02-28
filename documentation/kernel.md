# The Kernel

## Manage the Kernel

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

## Kernel Modules

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
