Here's how to set up a DNS server on Ubuntu or Debian.
```bash
sudo bash
apt-get update
apt-get install bind9
ufw allow Bind9 comment "DNS server"

cp ./etc/bind/* /etc/bind/
named-checkconf /etc/bind/named.conf
service bind9 restart
systemctl enable bind9
```
In your node's admin page 'Setup > Port Forwarding, DHCP and Services',
add an alias with:
* IP Address = your DNS server computer, and
* Alias Name = one of the names from ../client/data/etc/dnsmore.conf.

As usual, make sure you don't redefine an existing alias.
For example, don't make DNS-1 an alias for two different computers.

For each DNS zone that you choose to publish from this server:
```bash
sudo ./addzone <zone> # <zone> is the DNS name of the zone.
```
Use the RFC-2136 protocol to update records. The addzone script
creates a key that can be used to update anything in the zone.
Give that key to the owner of the zone. If needed, you can create keys
that enable updating a specific record (not any record in the zone).
See the comments in /etc/bind/named.conf.local for clues about this.

See ../client/README.txt for directions for updating records using nsupdate.

Don't edit the db.zone files directly. Use nsupdate.

These directions were adapted from:
* http://bahut.alma.ch/2013/01/personal-dynamic-dns.html
* https://serverspace.us/support/help/configure-bind9-dns-server-on-ubuntu/
* https://www.linuxbabe.com/ubuntu/set-up-authoritative-dns-server-ubuntu-18-04-bind9
