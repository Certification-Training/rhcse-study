This is Apache notes

I'm installing the "Web Server" group
`yum group info/install "Web Server"`

Still don't know the difference between `apachectl` and `systemctl`.
Anyway, I started and enabled it.

Config in /etc/httpd

`Include` generates errrors if the path afterwards doesn't match any file
`IncludeOptional` doesn't

My ServerRoot is "/etc/httpd"

http://localhost:8080/manual/ is my friend

I can't find semanage (needed to to policy changes to directories so SELinux and Apache can work together)
You can search with `yum whatprovides semanage` -> `policycoreutils-python`


