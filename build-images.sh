#!/bin/bash
$( ./set-env.py )
source openstack-utils.sh
set -e

	ADMINRC

	#IMAGE		"cirros-0.3.3-x86_64"	cirros-0.3.3-x86_64-disk.img	qcow2	bare	True
	#IMAGE		"Fedora-x86_64-20-20140618"	../Fedora-x86_64-20-20140618-sda.qcow2	qcow2	bare	True
	NETIMAGE	"cirros"		"http://download.cirros-cloud.net/0.3.3/cirros-0.3.3-x86_64-disk.img"				qcow2	bare	True
	NETIMAGE	"Fedora"	"https://download.fedoraproject.org/pub/alt/openstack/20/x86_64/Fedora-x86_64-20-20140618-sda.qcow2"	qcow2	bare    True
	NETIMAGE	"ubuntu"	"https://cloud-images.ubuntu.com/trusty/current/trusty-server-cloudimg-amd64-disk1.img"	qcow2	bare    True
	IMAGE-LIST

