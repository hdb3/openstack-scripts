source ~/openstack-scripts/admin-openrc.sh
nova keypair-add --pub_key acer.pub acer
nova secgroup-add-rule default icmp -1 -1 0.0.0.0/0
nova secgroup-add-rule default tcp 1 65535 0.0.0.0/0
