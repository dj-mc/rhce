# Network

You should be able to ping the other system:

```bash
ping -c1 192.168.33.14
ping -c1 192.168.33.15
```

## IP Address

```bash
ip addr
ip addr add 192.168.33.16 dev eth0
```

## Default Gateway

todo

## Network Mask

todo

## Hostname

- Edit `/etc/hostname`
- `hostnamectl`

## Name Resolution

- Edit `/etc/hosts`
- Dynamic resolution using DNS
- Add DNS servers to `/etc/resolv.conf`
- Static nameserver config
- Use Network Manager

## Network Device Naming

- `en`: ethernet
- `wl`: wireless LAN (WLAN)
- `ww`: wireless wide area network (WWAN)

Use firmware or BIOS information:

- Onboard devices
- PCI express hotplug devices

Use devices found physically:

- PCI card slot
- PCI express slot

## Tools

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
