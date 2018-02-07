# Chapter 5: Boot Process Notes

I need to know how to break into a RHEL box by memory!!

In the grub menu, erase `rhgb quiet` to get boot logs!

add `systemd.unit=emergency.target` to boot into the emergency shell (works on Linux).

To break in-

- Add `rd.break` to the boot params in grub menu- this interrupts the boot sequence before `/` is mounted (instead it's in `/sysroot`).
- Mount `/sysroot` as `/` and chroot to it: `mount -o remount,rw /sysroot` and `chroot /sysroot`.
- `passwd`
- SELinux isn't up yet. Tell it to autorelabel all files at next boot: `touch /.autorelabel`
- `exit` and `exit` to escape chroot and reboot
- login as `root` + your password

Assuming we're using the an old BIOS based system or a UEFI system in BIOS
mode, `grub.cfg` is in `/boot/grub2/grub.cfg`. Other places to look are
`/etc/grub2.cfg` and `/boot/efi/EFI/redhat/grub.cfg` (some of these are symlinks?)

Every entry has a line that starts with `linux16` and a line that starts with
`initrd16`. The `linux16` line is the one to add custom kernal params or other
systemd units to boot into.

To update grub:

- edit `/etc/default/grub` (for example, remove `quiet`)
- `grub2-mkconfig -o /boot/grub2/grub.cfg` (or I assume wherever `/etc/grub2.cfg
  points to`)
- reboot

# Stopped at "The GRUB 2 Command Line"
