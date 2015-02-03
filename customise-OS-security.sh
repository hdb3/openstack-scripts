source ~/openstack-scripts/admin-openrc.sh
nova keypair-add --pub_key x61.pub x61
nova secgroup-add-rule default icmp -1 -1 0.0.0.0/0
nova secgroup-add-rule default tcp 1 65535 0.0.0.0/0
