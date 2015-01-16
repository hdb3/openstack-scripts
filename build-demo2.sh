#!/bin/bash
$( ./set-env.py )
source openstack-utils.sh
set -e

	KADMIN		token-get
	ADMINRC
	NETIMAGE	"cirros"		"http://cdn.download.cirros-cloud.net/0.3.3/cirros-0.3.3-x86_64-disk.img"				qcow2	bare	True
	NETIMAGE	"Fedora"	"https://download.fedoraproject.org/pub/alt/openstack/20/x86_64/Fedora-x86_64-20-20140618-sda.qcow2"	qcow2	bare    True
	IMAGE-LIST

	EXTNET		ext-net
if [[ $# == 2 ]]
  then
	SUBNET	ext-net		ext-subnet	10.30.65.1      10.30.65.0/24	$1		$2
  else
	SUBNET	ext-net		ext-subnet	10.30.65.1      10.30.65.0/24	10.30.65.2	10.30.65.50
fi


	NET		mgmt-net
	SUBNET		mgmt-net	mgmt-subnet	172.16.0.1	172.16.0.0/24
	ROUTER		mgmt-router
	INTERFACE	mgmt-router	mgmt-subnet
	GATEWAY		mgmt-router	ext-net

	NET		server-net
	SUBNET		server-net	server-subnet	172.16.1.1	172.16.1.0/24

	NET		client-net
	SUBNET		client-net	client-subnet	172.16.2.1	172.16.2.0/24
