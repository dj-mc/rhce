# rhce

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

Use firmware or BIOS information

- onboard devices
- PCI express hotplug devices

Use devices found physically

- PCI card slot
- PCI express slot

### Tools

```bash
ip
nm-cli
nm-tui
nm-connection-editor
```

Or use GNOME's network GUI

```bash
ip addr
sudo nmtui
nm-connection-editor
```

Or manually create or modify `ifcfg-eth0`:  
`sudoedit /etc/sysconfig/network-scripts/ifcfg-eth0`
