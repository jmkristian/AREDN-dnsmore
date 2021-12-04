# AREDN-dnsmore
Here is software to enhance the DNS service in an AREDN network.
It enables the use of DNS names in any zone other than local.mesh
and DNS record types other than A (IP address).
For example, CNAME records can define aliases for local.mesh names,
and MX records can guide email forwarding.

Standard DNS servers are connected to the AREDN network.
See server/README.txt for directions to set up a DNS server on Ubuntu or Debian.
Data are stored into the servers using the RFC 2136 protocol.
See client/README.txt for directions for using nsupdate.

A client package is installed into AREDN nodes,
to cause them to relay queries to the DNS servers.
See client/README.txt for directions to build and install this package.

The additional DNS servers should *not* define records in the local.mesh zone.
That zone should only be managed by the core AREDN software.
