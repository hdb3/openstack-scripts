#!/bin/bash
$( ./set-env.py )
source openstack-utils.sh
set -e
	ADMINRC
	EXTNET		ext-net1	external1
	SUBNET		ext-net1	ext-subnet1	10.30.65.1      10.30.65.0/24	10.30.65.80	10.30.65.89

	NET		mgmt-net
	SUBNET		mgmt-net	mgmt-subnet	172.16.0.1	172.16.0.0/24
	ROUTER		mgmt-router
	INTERFACE	mgmt-router	mgmt-subnet
	GATEWAY		mgmt-router	ext-net1

# test network on port 2

	COMMAND		"sleep 5"
	EXTNET		ext-net2	external2
	SUBNET		ext-net2	ext-subnet2	192.168.0.1      192.168.0.0/24	192.168.0.100	192.168.0.199

	NET		test-net
	SUBNET		test-net	test-subnet	172.16.1.1	172.16.1.0/24
	ROUTER		test-router
	INTERFACE	test-router	test-subnet
	GATEWAY		test-router	ext-net2
