## Reading

To enable a client to read information from additional name servers:

`./build`

... and upload [built](built)/dnsmore_*.ipk to the client's AREDN node, using
the node's 'Setup > Administration' page. Under 'Package Management > Upload
Package', click 'Browse...', select the .ipk file and click 'Upload'.

That node and the computers directly connected to it will be able to read DNS
records from the servers listed in
[data/etc/dnsmore.conf](data/etc/dnsmore.conf). (The connected computers were
already configured to query the node, and dnsmore configures the node to
forward queries to the other servers.)

As usual, you can't upload the .ipk file to a node that's an active tunnel
client. You can disable the tunnel client, upload the .ipk file and then
re-enable the tunnel client. Of course, this means you can't upload the .ipk
file via the tunnel.

## Writing

To publish information via DNS, choose a zone. That's a domain name, which
will be a suffix of the names you publish. Try not to choose a zone that
someone else wants to manage. Don't choose local.mesh, or any name that ends
with .local.mesh. (Those domains should only be managed by the AREDN nodes.)
A zone that can't exist in the public Internet is a safe choice. If the zone
exists or could exist in the public Internet, it's best if you own it there
(but it's not required).

Ask the operator of a name server to help you publish your zone. They'll tell
you the name of your primary name server and a secret key. Store the key in a
file in this format:
```
key "yourzone.org" {
  algorithm hmac-md5;
  secret "bINaryCyberCrudD24CvBI==";
};
```
Keep the secret, secret. Anyone who knows it can modify data in your zone.
Restricting access to the file is recommended.

You can use [nsupdate](https://linux.die.net/man/8/nsupdate)
to store information into the primary name server. For example:
```
nsupdate -k your.keyfile
> server dns-1.local.mesh
> zone yourzone.org.
> update add smtp.yourzone.org. 300 MX 10 n0call-mailserver.local.mesh
> update add  www.yourzone.org. 300 CNAME n0call-webserver.local.mesh
> send
```
For Linux, nsupdate is usually packaged in dnsutils or bind-utils.
For Windows, nsupdate.exe is included in the BIND 9 package from
[ISC](https://www.isc.org/download/), or it can be installed in
[Cygwin](https://cygwin.com/index.html) or the
[Windows Subsystem for Linux](https://docs.microsoft.com/en-us/windows/wsl/about).

After you update DNS records in the server, it will take some time for clients
to see the new data. The old records are cached, for as long as the TTL (time
to live) with which they was stored. Be patient. If you're experimenting,
store experimental data with fairly short TTL's, so it won't take a long time
to correct mistakes.
