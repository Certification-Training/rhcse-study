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

```bash
get_link() {
    local -r document_root="/var/www/html"
    local -r item="$1"
    local -r full_path="$(readlink -f $item)"
    local -r hostname="http://localhost:8080"
    echo "$full_path" | sed "s|$document_root|$hostname|"
}
```

`yum reinstall man-pages` - wtf do they not keep these installed?

Okay, I now have an Ansible playbook to set up all this stuff for me

Check Apache syntax with `httpd -t` or `httpd -S`

## Using user content

- Change /etc/httpd/conf.d/userdir.conf and add UserDir public_html
- Give apache user rights to /home/vagrant and /home/vagrant/public_html

```
setfacl -m u:apache:x /home/vagrant
setfacl -m u:apache:x /home/vagrant/public_html
```

NOTE: might need to change permissions on docs craeated in there too. Nope. Don't need to

- `setsebool -P httpd_enable_homedirs 1`

The `IncludesNoExec` stops script execution. I might want to change that...

I can use the `mod_authnz_ldap` for LDAP auth

## VirtualHosts

To use Vhosts, I need to make sure the client includes the IP address with the FQDN

NOTE: I changed ServerName to 127.0.0.1:80 to shut up `httpd -S`

Vhosts docs: http://localhost:8080/manual/vhosts/

So you setup virtualhosts by making sure the <subdomain>.<domain> routes to the
right IP (/etc/hosts / DNS) then Apache will read the subdomain and match to
the right vhost

- Create a conf file for it (/etc/httpd/conf.d/vhost-dummy.conf).
- Add the stuff from the book:

```
<Directory "/srv/dummy-host/www">
    Require all granted
</Directory>

<VirtualHost *:80>
    ServerAdmin webmaster@dummy-host.example.com
    DocumentRoot /srv/dummy-host/www
    ServerName dummy-host.example.com
    ServerAlias www.dummy-host.example.com
    ErrorLog logs/dummy-host.example.com-error_log
    CustomLog logs/dummy-host.example.com-access_log common
</VirtualHost>
```

- Create the directory and set the context for it

```
mkdir -p /srv/dummy-host/www
semanage fcontext -a -t httpd_sys_content_t '/srv/dummy-host/www(/.*)?'
restorecon -R /srv
```

- Restart the httpd daemon

```
systemctl restart httpd
```

- Add to my Mac's /etc/hosts

```
# This is for Apache tests with VMs
127.0.0.1       dummy-host.example.com dummy-host
```

- flush DNS cache (Mac side):

```
sudo dscacheutil -flushcache
sudo killall -HUP mDNSResponder
```

So this works, but nslookup and friends won't listen to /etc/hosts for some
dumb reason: https://apple.stackexchange.com/a/158166/249419

Then you can reach http://dummy-host.example.com:8080/

I'm trying do to the smae thing for luv-linex vhost, but I missed the dash.
Notes: make sure DNS is right. 

### semanage fcontext

- Use `semanage fcontext -l` and grep to see what you set
- Use `semanage fcontext -d -t httpd_sys_content_t <regex>` to delete stuff
- Use `semanage fcontext -a -t httpd_sys_content_t <regex>` to add

## HTTPS

Check mod status with `httpd -M`

