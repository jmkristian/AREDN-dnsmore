# On the AREDN node:
sudo bash
cp -r node/* /
/etc/init.d/dnsmore start
/etc/init.d/dnsmore enable

# On the DNS server:
# https://serverspace.us/support/help/configure-bind9-dns-server-on-ubuntu/
# https://www.linuxbabe.com/ubuntu/set-up-authoritative-dns-server-ubuntu-18-04-bind9
sudo bash
apt-get update
apt-get install bind9
ufw allow Bind9

cp server/etc/bind/* /etc/bind/
named-checkconf
named-checkzone jkristian.com /etc/bind/db.jkristian.com
service bind9 restart
systemctl enable bind9

# https://www.webmin.com/
