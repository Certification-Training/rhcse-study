# These notes are from the Safari Books Online Video thingie

(See ~/Documents/PDFs/safarirhcsa.pdf on my work mac)

- Look up the Objectives via the web site

# Exam Questions (1)

- Reset root password

https://www.rootusers.com/how-to-reset-root-user-password-in-centos-rhel-7/

In boot file thing remove gui boot and quiet things options in
then add rd.break like the site says.

rd.break means stop right after loading the initramfs

mount tells you that / is mounted on rootfs (rw) which is a temporary file system. We need to remount / on sysroot

mouunt -r remount,rw /sysroot

We want the contents of sysroot to be our root.

( this differs from link )

```
# we need devices to be available for password change
mount -o bind /dev /sysroot/dev

# we want proc for some reason
mount -t proc proc /sysroot/proc

chroot /sysroot

passwd
```

Make the .autorelabel file

THis is why

SELinux hasn't been loaded so /etc/shadow doesn't have the right context label and SELinux will notice and complain

you can load selinis wiht `load_policy -i` and do a ls -lZ on /etc/shadow or restore default contexts with  restorcon I think

exit chroot and reboot

The two options to remove are "rhgcb" and "quiet" in the grub boot config. Then you can see the boot process.

You can also remove this from /etc/default/grub and `grub2-mkconfig -o /boot/grub2/grub.cfg` to make it sticky?
but only do this if you're confident otherwise it's bad?

- Run cron job

You can modigy /etc/crontab , something in cron.d/, whatever

You can use the `logger` command to write to syslog

- Make users password expire in 90 days

The author is Sander van Vugt

This is in /etc/login.defs or /etc/default/useradd

- Create users and stuff (see pdf)

He created the groups (groupadd students), then used `useradd` and `userdel` to do stuff, `id` <username> do check groups

The /etc/skel dir copies stuff to new user's home directory

- Create direcoty /data and add all the stuff from the pdf

 To let only people who create a file delete it, you need sticky bits, (chmod +t) (thisis Exam QUestions 2.1.4)

 For the Anna question (2.1.5) make her the owner of the directories, and she will be able to delete all

 TO make profs have read on all, use ACLs you also need a default one

 ExamQuestions2.1

```
mkdir -p /date/{students,profs}
cd /data
chgrp profs profs
chgrp students students
ls -l # verify
chmod 770 *
chmod g+s *
chmod +t * # sticky bit (4)
chown anna *
setfacl -R -m g:profs:rx students/ # -R is recursive
getfacl students # check
# You can igonre ACL masks. Nobody uses it.
# We need this ACL to be inherited by child directorys
# SO define the ACL twice- one for existing, one for new stuff
# lets do if for new stuff
setfacl -m  d:g:profs:rx students # Added the d thing to make it inherit?
# !ge repeats the last commmand started with ge
# We can test this by sudo su linda ; cd /data/students
# Take sufficient time to see what you do is working!
```

He did something where he created a file under linda's home directory as root and linda was able to delete it. This is because deleting is a directory level permission and linda has directory level permissions on her home.

# Exam Questions (3)

- Configure storage according to the following specifica/ons. All devices should be mounted automa/cally aher restart.

The MiB means "multiple of 1024bytes".

```
# In KVM, the hard ddisk is vda in VMWare is sda
fdisk /dev/sda
: p # see size
: p # primary
: +500M # Add 500 MiB partition
: # Learn how to use LVM...
: p
: # Just get a tutorial here...
Use partprobe to push modifications to push changes to kernel
Then add it to /etc/fstab
mount it `mount -a`
# LVM stuff
useing pvcreate, vgcreate, lvcreate -n <name> -L 200 M /dev/vgswap, mkswap
free -m to see the swap stuff
```

Reboot early, don't wait until the end of the exam to reboot!

Email him when I pass!

We can't create snapshots from the VM

On the exam, start with everything relating to Partitions first, then reboot, then do everything else!

- restore default SElinux to / 

`restorecon /`

Vim `/etc/sysconfig/selinux` to ensure enforcing

firewall-cmd --list-all

You need to be carefull to make it persistent with firewall stuff.

# Bonus (the ftp server)

For FTP, make sure it's working before enabling selinux

He's using lftp to test the ftp

You can look at /var/log/mesages to see some SElinux stuff

Then use sealert -l "hex-code-you-findin-message" to get suggestions with  confidence intervals on how likely it is to work. How the heck do they get those? 

Safaribooks Online has an exam walkthrough. 
