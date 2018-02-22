From SafariBooksOnline by Sander van Vugt

(I think he wrote my book...)

- Setting up a lab env
- Configure remote auth
- Kerberized NFS
- iSCSI Target and Initiator
- Shell Scripting

He's going to build his IPA server (LDAP server)

LDAP is like an Active Directory server.

There are two ways to build the lab environment - use his images

the Realm is part of Kerberos- typically an uppercased domain name

modify /etc/hosts to point to me

```
10.0.0.10 ipa-server.bbkane.com
```

using password `password`

Doing some work- I added 8.8.8.8 to the DNS resolvers.

Apparently, I can get the lab images from rhatcertification.com (Sander's website)

Check firewall config with `firewall-cmd --list-all`

I need to give this VM 2GB...

`systemctl enable --now vsftpd` only works on Cent7.2+, not 7.0, the RHCSE test version. Instead use `systemctl enable vsftpd; systemctl start vsftpd`

It failed with some Java error... I think I'm screwed... I'm just going to have
to follow along and try to do this after class...

Now he's configuring a remote authentication. Kerberized services only make
sense where you have Kerberized users as well- setting up remote authentication.

In the RHCE, Kerberos is provided through the IPA server. You don't have to install it.

IPA stand for Identity, Policy, and Authorization

authconfig-tui is legacy, and don't use authconfig or authconfig-gtk either-
they are complicated CLI or require a GUI to. The RHCSE won't have a GUI and
you don't want to install one. Use ipa-client-install to connect to an IPA
server.

Make sure you set the static ip before you do any auth stuff. He's using `nmtui` to configure it.
But the best tool is `nmcli` (long answer tomorrow)
Use your IPA server's IP for DNS 

He's using `authconfig-tui` even though it's not the best way either - 'Cache
Information', 'Use LDAP', 'Use Shadow Passwords', 'use LDAP Authentication',
'Use Kerberos' 'Local authorization is sufficient' are the boxes to be checked.
If you get an install thingie, you need to 'yum groups install "Directory
Client"'

It doesn't show up in `yum gruops list`. Instead use `yum groups list hidden` to see it.

In LDAP Settings, make sure you use the name instead of the IP address.

I need to make sure that my VM has 2GB before I run this stuff.

In a real environment, use `authconfig` for all the required options:

```
yum groups intall "Directory Client" && \
authconfig --enable-shadow --endableldap --enableldapauth --ldapserver=labapi2.example.com \
    --ldapbased=dc=example,dc=com --enableldaptls --ldapuploadcacert=ftp://labapi2.example.com/pub/ca.crt \
    --enablekrb5 --enablecrb5kdcdns --enablecrb5realmdns --enablesssdauth
```

Setting this up is horrible...

Look up `ipa-client-install` to do it. Also look up autofs

If you can't find a route to the host, try `systemctl stop firewalld`

You use a keytab file to connect IPA and kerberos..

And... I gave up on all of it... I'm going to just study the book instead.
