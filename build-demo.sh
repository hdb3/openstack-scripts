#!/bin/bash
$( ./set-env.py )
source openstack-utils.sh
set -e

	ADMINRC
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
