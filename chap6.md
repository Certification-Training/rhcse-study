# Filesystem admin

# Partition Management

`fdisk` doesn't support GPT partitions but `gdisk` and `parted` do.

`df` and `fdisk -l` list space used

`mount` seems to attach device to a folder in the `/` tree? `findmnt` does something in an actual tree view

## fdisk

Works with partitons using MBR- newer systems with UEFI use GUID Partition
Table (GPT) which doesn't work so well with fdisk - use gdisk or parted for
those.



