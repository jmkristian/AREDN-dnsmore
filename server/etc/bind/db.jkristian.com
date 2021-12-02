$ttl 60
jkristian.com.  IN  SOA W6JMK-VM-alias.local.mesh. postmaster.jkristian.com. (
  5  ; version of this file
  60 ; refresh
  60 ; retry
  60 ; expire
  30 ; negative cache TTL
  )
jkristian.com.  IN  NS	W6JMK-VM-alias.local.mesh.
jkristian.com.  IN  MX	10 W6JMK-postoffice.local.mesh.
krelm           IN  A	10.118.99.99
fnorg           IN  A	10.118.99.100
aka             IN  CNAME	krelm.jkristian.com.
