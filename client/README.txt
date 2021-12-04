# To enable a client to use additional DNS servers:
./build
# ... and upload built/dnsmore_*.ipk to the client's AREDN node,
# using the node's 'Setup > Administration' page. Under 'Package
# Management > Upload Package', click 'Browse...', select the
# .ipk file and click 'Upload'.

# That node and all the computers connected to it will be able to
# resolve DNS names via the servers listed in data/etc/dnsmore.conf.
# (The connected computers were already configured to query the node,
# and now the node is configured to relay queries to other servers.)

# As usual, you can't upload the .ipk file if the node is an active
# tunnel client. To handle this, disable the tunnel client, upload
# the .ipk file and then re-enable the tunnel client. Of course,
# this means your computer must be connected directly to the node.

# If you aim to publish information via DNS, choose a zone name
# and ask the operator of a DNS server to help you publish it.
# They'll give you a secret key. Store it in a file in this format:

key "yourzone.com" {
  algorithm hmac-md5;
  secret "bINaryCyberCrudD24CvBI==";
};

# Keep the secret, secret. Anyone who knows it can modify your zone.
# Restricting access to the file is recommended.
# Use nsupdate to store information in the DNS server. For example:

nsupdate -k your.keyfile
> server dns-1.local.mesh
> zone yourzone.com.
> update add foo.yourzone.com. 300 A 1.2.3.4
> update add foo.yourzone.com. 300 TXT "Hello, world!"
> send

# After you update information in the server, it will take some time
# for clients to see it. The old information is cached, for as long
# as the TTL time with which it was stored. Be patient. If you're
# experimenting, store experimental data with fairly short TTL's,
# so it won't take a long time to correct mistakes.
