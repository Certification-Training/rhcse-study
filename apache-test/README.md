This is Apache notes

I'm installing the "Web Server" group
`yum group info/install "Web Server"`

There's also the `web-server` group. `yum info` for each one indicates that they're the same

Still don't know the difference between `apachectl` and `systemctl`.
Anyway, I started and enabled it.

Config in /etc/httpd

`Include` generates errrors if the path afterwards doesn't match any file
`IncludeOptional` doesn't

My ServerRoot is "/etc/httpd"

httpd-manaal installs the manual at: http://localhost:8080/manual/ (assuming 8080 is the VM's forwarded port)

I can't find semanage (needed to to policy changes to directories so SELinux and Apache can work together)
You can search with `yum whatprovides semanage` -> `policycoreutils-python`

Exercise 14-3 is something I can actually use!

TODO: So it's saying my connection is not secure. I want to either generate a
cert or use Let's Encrypt to get one!

Also, it appears `firewalld` is not running... I guess centos/7 doesn't load it
by default or something...

```
get_link() {
    local -r document_root="/var/www/html"
    local -r item="$1"
    local -r full_path="$(readlink -f $item)"
    local -r hostname="http://localhost:8080"
    echo "$full_path" | sed "s|$document_root|$hostname|"
}
```

`yum reinstall man-pages` - wtf do they not keep these installed?
