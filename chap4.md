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
dirs are 0777 - 0002 == 1775 and for files is 0666 - 0002 == 0664.

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

# Stopped at TABLE 4-5
## TODO: go through the exercise and use ACLs on a /srv/shared-files dir
