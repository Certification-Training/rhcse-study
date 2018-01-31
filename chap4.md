File permissions

r -> 4
w -> 2
x -> 1

And you can remmember these cause they decend by halves and are listed in order with `ls -l`

Special bits

- SUID (`s` in user part of `ls -l`)
  - file: when the file is executed, the effective userid of the process is that of the file
  - dir: no effect
- SGID (`s` in group part of `ls -l`)
  - file: when the file is executed, the effective group id of the process is that of the file
  - dir: gives files created in teh directory the same group ownership as that of the dir
- sticky bit (`t`  at the end of `ls -ld /tmp`)
  - file: no effect
  - dir: files in the dir can be renamed or removed only by their owners

Note:

Even if a user doesn't have permission to write a file, but does on the directory, they can write the file anyway cause directory rights override file permissions

There are also more permissions usable with `lsattr` and `chattr`

- `a`: append only
- `d`: no dump, no backups with dump command (not installed by default on my test vm)
- `e`: extend format: set with ext4 filesystem; an attribute that may not be removed (TODO: look this up?)
- `i`: immutable: no changes!

There are other attributes, but not for ext4 and XFS filesystems

`umask` is the command sets default permissions on files created. It won't let
you auto-add the executable bit. It seems to work by starting with base
permissions (0777 for dirs, 0666 for files), and subtracting the umask (default
0002 for users and 0022 for root). This means, by default, the permissions for
dirs are 0777 - 0002 == 0775 and for files is 0666 - 0002 == 0664.

ACLs

RHEL uses the XFS file system.

Managing ACLs

`getfacl <name>` and `setfacl <name>`

These are like more fine grained permissions. To let user `micheal` specifically have rwx on a file, you'd

    setfacl -m u:micheal:rwx <file>  # give micheal rwx on file
    setfacl -x u:micheal: <file  # rm micheal's acls
    setfacl -m g:teachers:r <file>  # give the teacher group r
    setfacl -m u:micheal:- <file>  # rm all acls for micheal
    setfacl -b <file>  # rm all ACLs for file

Before that works, though, we need to set it on the directory.

Table 4-5 has a nice table about acl options.

I'm skipping the nfs_acl stuff.

Now I'm on iptables.

To get iptables back, I need `yum install iptables-services`

Standard ports are in /etc/services

A basic iptables flowchart

```
iptables 
  -t  # tabletype
    filter  # filter packets, default
    nat  # aka masquerading
  <action_direction>
    -A, --append  # append rule to end of chain
      INPUT  # incomng packets
      OUTPUT  # outging packets
      FORWARD  # packets routed through me
    -D, --delete  # delete rule by number or packet pattern
      INPUT  # incomng packets
      OUTPUT  # outging packets
      FORWARD  # packets routed through me
    -L, --list  # list rules in chain
    -F, --flush # flushes all rules in current iptables chain
  <packet_pattern>
    -s <ip_address>  # All packets are checked for a specific source IP
    -d <ip_address>  # All packets are checked for a specific dest IP
    -p <protocol> --dport <port_num>
    -i <interface>
  -j <what_to_do>
    DROP
    REJECT
    ACCEPT
```

## firewalld

Firewalld uses a "zones" concept to decide what to do with packets. A zone has two parts:
- what's in it (source addresses/interfaces)
- what to do with traffic coming to it (drop, accept, etc)

Table 4-8 has the default zones (drop, block, public, ...)

Use the graphical `firewall-config` tool to work with zones or the terminal `firewall-cmd`

Use the --permanent switch to make changes survive reboot, then --reload to make the change now

NOTE: there's not a ton here...

## SSH Key based auth

known_hosts: client compares server's key to this.
authorized_keys: server compares user from client to this
So, to move the public key over, use `ssh-copy-id`. This is the same as logging
into the server and adding your public key `id_<protocol>.pub` to the
`authorized_keys` file.

# "A Security-Enhanced Linux Primer"

The SELinux security model is based on subjects, objects, and actions. A
subject is a process, such as a running command or an application such as the
Apache web server in operation. An object is a file, a device, a socket, or in
general any resource that can be accessed by a subject. An action is what may
be done by the subject to the object.<Paste>

A context is a label used by the SELinux security policy to determine wheter a
subject's action on an object is allowed.

SELinux stuff in /etc/selinux

See current status with `sestatus`

Change mode with `setenforce`

Give users profiles:

    semanage login -a -s user_u michael  # No sudo for you ****
    semanage -d michael  # So sorry, here's your sudo back
    semanage login -m -S targeted -s "user_u" -r s0 __default__

There's a table 4-11 of user stuff. What I want to know is how this interacts with the `wheel` group.

Use `getsebool` and `setsebool` to manage boolean settings
Use `-P` to make it persistent

Use `semanage boolean -l` to list all booleans

    -rw-------. root root system_u:object_r:admin_home_t:s0 anaconda-ks.cfg

`ld -Z` lists 4 SELinux thingies:

- user: system_u)
- role: object_r)
- type: admin_home_t)
- mls level: s0)

You can use `chcon` to change the SELinux context, but that won't survive a
file relabeling. Instead, they want you to modify contexts in the SELinux
policy with `semanage fcontext` and use `restorecon` to change file contexts.

The regular expression `/ftp(/.*)?` matches the `ftp/` directory and all files
in it.

Assign a type context of `public_content_t`:

    semanage fcontext -a -t public_content_t '/ftp(/.*)?'
    restorecon

See a practical example of this:
https://www.techrepublic.com/blog/linux-and-open-source/practical-selinux-for-the-beginner-contexts-and-labels/

Use the `-Z` option on `ls`, `id`, `ps` to see different contexts.

Here's another deep SELinux tutorial:
https://access.redhat.com/documentation/en-us/red_hat_enterprise_linux/6/html/security-enhanced_linux/chap-security-enhanced_linux-selinux_context

SELinux violations are in `/var/log/audit/audit.log`.

Use `ausearch -m avc -c sudo` to see SELinux events associated with `sudo`. (avc
stands for Access Vector Cache)

Use `ausearch -m` to see all message types

`sealert -a /var/log/audit/audit.log` will scan the audit log and try to figure
out what's wrong. It's one to remember.

# Stopped right before Ex 4.3

Screw it, I'm tired of stuyding this. Going to the quiz now:

1. chmod 600 question1
2. chown professor:group question2
3. chattr +a question3
4. getfacl question4
5. - looking at notes - setfacl -m g:managers:r /home/project/project5
6. setfacl -x g:temps /home/project/secret6
7. 80 (in /etc/services)
8. - looking at notes - ???
9. ssh-keygen -t dsa
10. ~/.ssh/authorized_keys
11. setenforce Enforcing (that was an interesting jaunt through searching my path...)
12. - notes - semanage user -l
13. getsebool -a
