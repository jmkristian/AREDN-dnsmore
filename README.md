# AREDN-dnsmore
Here is software to enhance the DNS service in an AREDN network.

Standard DNS servers are connected to the AREDN network.
See server/README.txt for directions for setting up a DNS server on Ubuntu or Debian.
Data are stored into the servers using the RFC 2136 protocol.
See client/README.txt for directions for using nsupdate.

A client package is installed into AREDN nodes, to cause them to relay queries to the DNS servers.
See client/README.txt for directions to build and install this package.
