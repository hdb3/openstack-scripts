#!/bin/bash
$( ./set-env.py )
source openstack-utils.sh
set -e

	ADMINRC
	#IMAGE		"cirros-0.3.3-x86_64"	cirros-0.3.3-x86_64-disk.img	qcow2	bare	True
	#IMAGE		"Fedora-x86_64-20-20140618"	../Fedora-x86_64-20-20140618-sda.qcow2	qcow2	bare	True
	NETIMAGE	"cirros"		"http://cdn.download.cirros-cloud.net/0.3.3/cirros-0.3.3-x86_64-disk.img"				qcow2	bare	True
	NETIMAGE	"Fedora"	"https://download.fedoraproject.org/pub/alt/openstack/20/x86_64/Fedora-x86_64-20-20140618-sda.qcow2"	qcow2	bare    True
	NETIMAGE	"ubuntu"	"https://cloud-images.ubuntu.com/trusty/current/trusty-server-cloudimg-amd64-disk1.img"	qcow2	bare    True
	IMAGE-LIST

	EXTNET		ext-net1		external1
	SUBNET	ext-net1		ext-subnet1	10.30.65.1      10.30.65.0/24	10.30.65.2	10.30.65.50
	NET		demo-net1
	SUBNET		demo-net1	demo-subnet1	172.16.0.1	172.16.0.0/12
	ROUTER		demo-router1
	INTERFACE	demo-router1	demo-subnet1
	GATEWAY		demo-router1	ext-net1

	COMMAND		"cinder		create	--display-name	demo-volume1	1"

	COMMAND		"heat		stack-create	-f	test-stack.yml	-P	\"ImageID=cirros;NetID=\$NET_ID\"	testStack"
	END
