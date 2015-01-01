#!/bin/bash
source openstack-utils.sh
set -e

	ADMINRC
	KADMIN		token-get
	#COMMAND		"wget http://cdn.download.cirros-cloud.net/0.3.3/cirros-0.3.3-x86_64-disk.img"
	#IMAGE		"cirros-0.3.3-x86_64"	cirros-0.3.3-x86_64-disk.img	qcow2	bare	True
	IMAGE		"Fedora-x86_64-20-20140618"	../Fedora-x86_64-20-20140618-sda.qcow2	qcow2	bare	True
	NETIMAGE	"cirros-0.3.3-x86_64"		"http://cdn.download.cirros-cloud.net/0.3.3/cirros-0.3.3-x86_64-disk.img"				qcow2	bare	True
	#NETIMAGE	"Fedora-x86_64-20-20140618"	"https://download.fedoraproject.org/pub/alt/openstack/20/x86_64/Fedora-x86_64-20-20140618-sda.qcow2"	qcow2	bare    True
	IMAGE-LIST

	EXTNET		ext-net
	#		network name	subnet name	gateway		CIDR		alloc start	alloc end
	#  SUBNET	ext-net		ext-subnet	10.30.65.1      10.30.65.0/24	10.30.65.2	10.30.65.50
	SUBNET	ext-net		ext-subnet	192.168.1.254      192.168.1.0/24	192.168.1.220	192.168.1.239
	NET		demo-net
	SUBNET		demo-net	demo-subnet	172.16.0.1	172.16.0.0/12
	ROUTER		demo-router
	INTERFACE	demo-router	demo-subnet
	GATEWAY		demo-router	ext-net

	COMMAND		"cinder		create	--display-name	demo-volume1	1"

	COMMAND		"heat		stack-create	-f	test-stack.yml	-P	\"ImageID=cirros-0.3.3-x86_64;NetID=\$NET_ID\"	testStack"
	END
