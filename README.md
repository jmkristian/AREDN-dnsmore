# AREDN-dnsmore
Here is software to enhance the DNS service in an AREDN network.
It enables the use of DNS names in zones other than local.mesh,
and DNS records other than type A (IP address).
For example, CNAME records can define aliases for local.mesh names,
and MX records can guide email forwarding.

To implement this, standard DNS servers are connected to the AREDN network.
See [server/README.md](server/README.md)
for directions to set up a DNS server on Ubuntu or Debian.
Data are stored into the servers using the RFC 2136 protocol.
See [client/README.md](client/README.md) for directions for using nsupdate.

A client package is installed into AREDN nodes,
which causes them to forward queries to the DNS servers.
See [client/README.md](client/README.md)
for directions to build and install this package.

The additional DNS servers should *not* define records in the local.mesh zone.
That zone should only be managed by the core AREDN software.
