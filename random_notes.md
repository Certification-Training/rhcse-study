# DNS

WHen you try to access a non-ip (hostname/fqdn).
it goes to libresolve
which looks for a '.' at the end of the name, which meeans this is an fqdn so it won't traverse the search domain (instead it will immediatly query /etc/hosts and DNS to get the IP for the name directly)
if there's not a '.' at the end of the name, It will check for any periods. If there's enought to look like an FQDN, then it will do the /etc/hosts | DNS thing (like before)
Then it will try append the search domains in /etc/resolv.conf to the name adn query /etc/hosts | DNS like before

alias record: name -> ip address
canonical name record: name -> name (must keep looking up to get to ip address)

`dig` usage:
give it a fqdn (not a shortname)
it returns stuff, most notably alias/cname records with TTLs from DNSs

TODO: look up how root DNS servers work - `dig SOA`

# Website Monitoring

## Google SRE Book https://landing.google.com/sre/book/index.html

white-box monitoring: monitoring internals of system- logs, JVM stats, etc.
black-box monitoring: external behaviour as a user would see it

Four golden signals:
- latency: time to service requests - differentiate between successful request latency and unsuccessful, and measure by histogram to not ignore tails
- traffic: something/second - http requests / second or transactions / second, etc.
- errors: rate of requests that fail explicitly or implicitly
- saturation: how full the system is, memory/IO, whatever. Also concerned with times (your database will fill up in 2 days...)

It's best to measure these in histograms (not just means- tails are important!)

Keep monitoring simple!

## Evolution of Data at Reddit  https://redditblog.com/2018/02/28/the-evolution-of-data-at-reddit/

I remember asking what the current data architecture looks like. What
technologies are used? What do the data pipelines and ETL systems look like?
How many people are working on this, and how does it integrate into product
decisions?

- Pig scripts thorugh HAProxy and pixel-tracking logs.
- mapreduce with Amazon's Elastic MapReduce
- Apache HIVE to run SQL on HDFS
- LinkedIn made Askaban to sovle Hadoop job dependedencies (how does it compare to Airflow?)
