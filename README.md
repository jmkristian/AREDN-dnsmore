# AREDN-dnsmore
Here is technology to enhance the
[Domain Name Service](https://en.wikipedia.org/wiki/Domain_Name_System)
in an [AREDN](https://www.arednmesh.org/aredn-advantage) network.
This enables the use of domain names in zones other than local.mesh,
with any record type. For example, CNAME records can define aliases
for local.mesh names, and MX records can guide email forwarding.

To implement this, standard name servers are added to the AREDN
network. A package is installed into AREDN nodes that causes them
to forward queries to these additional name servers. See
[client/README.md](client/README.md) for directions to build and
install this package.

Multiple administrators can store data into the name servers.
Typically, each administrator will maintain their own subtree of
domain names. See [client/README.md](client/README.md) for
directions.

To set up a name server, see the directions in
[server/README.md](server/README.md).
