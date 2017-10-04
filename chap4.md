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

## Stopped at "The umask"
