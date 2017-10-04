```
ls -Z # Get SELinux context
```

I guess my vagrant box doesn't have `locate` installed

There are no files in my `/usr/share/doc` dir... (`find . -type d`)

# Networking:

Given an IP and a netmask, IP & netmask = network portion of IP. This basically chops off everything after the netmask.

Ex:

    123.456.789.012 -- IP
    &
    255.255.255.0   -- subnet mask
    =
    122.456.789.0   -- netwwork portion of IP

This is because `1 & b = b` and `0 & b = 0`

Three key IP addresses in a network:

network address: first IP in a range
broadcast address: last address in the range
subnet mask: used to identify host and network portions of IPs

Ex:
The network 192.168.122.0/24 consist of
network address: 192.168.122.0 (first address)
broadcast address: 192.168.122.255 (last address)
subnet mask: 255.255.255.0  (the /24 in dotted decimal)

Q: why assign a interface an IP and a netmask? Why not just an IP?
A: You have to tell it what "group" it's in. So you assign it a specific IP, then a mask. and that's the stuff it's allowed to talk to before forwarding the default gateway.

# Network tools

| ifconfig                     | ip [-s] link *or* ip addr         | Shows the link status and IP address information for all network interfaces                  |
|------------------------------|-----------------------------------|----------------------------------------------------------------------------------------------|
| ifconfig eth0 <ip> <netmask> | ip addr add <ip/netmask> dev eth0 | assigns an IP address and netmask to the eth0 interface                                      |
| arp                          | ip neigh                          | shows the arp table                                                                          |
| route *or* netstat -r        | ip route                          | shows the routing table                                                                      |
| netstat -tulpna              | ss -tuna                          | Shows all listening and non- listening sockets, along with the programs to which they belong |

When using `traceroute`, sometimes a firewall will bock UDP packets. If so, run it with the `-I` or `-T` for ICMP or TCP probe packets.

Use `dhclient <interface>` to call DHCP for an IP address, and sets up a default route and adds DNS server to /etc/resolv.conf

Use `sudo ss -tunap4` to see processes using ports. If no `sudo` is specified, then you don't get process IDs

Use `systemctl status network` and `nmcli dev status` to check logs and interface status. Use `systemctl restart network` if you lose wifi.

I'm trying to set up a different profile for enp0s3, but I'm failing at:

```
root@rhcse-study-vm-1 ~]# nmcli connection add con-name "enp0s8-work" type ethernet ifname enp0s8
Connection 'enp0s8-work' (bd40239a-b3c0-473b-a98e-958139d73f10) successfully added.

[root@rhcse-study-vm-1 ~]# nmcli con mod "enp0s8-work" ipv4.addresses "192.168.20.100/24 192.168.20.1"
Error: failed to modify ipv4.addresses: invalid prefix '24 192.168.20.1'; <1-32> allowed.
```

I should use `nmtui` for all my IP configuration needs! So much easier than `nmcli`

A lot of the network configs are actually stored in `/etc/sysconfig/network-scripts`

## Hostname Configuration Files

- `/etc/hostname`

Name me

- `/etc/hosts`

Handwrite some hosts, baby!

- `/etc/resolv.conf`

nameserver locations. Overwritten by Network Manager

- `/etc/nsswitch.conf`

Specifies priorities for looking up hosts with the `host: files dns myhostname` line

`ifup <interface>` turns up an interface

## Questions

9. ip addr add 192.168.100.100/24 dev eth0
