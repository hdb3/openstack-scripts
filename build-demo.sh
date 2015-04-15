#!/bin/bash
$( ./set-env.py )
source openstack-utils.sh
set -e

	ADMINRC
	EXTNET		ext-net1		external1
	SUBNET	ext-net1		ext-subnet1	192.168.1.1      192.168.1.0/24	192.168.1.100	192.168.1.149
	NET		demo-net1
	SUBNET		demo-net1	demo-subnet1	172.16.0.1	172.16.0.0/24
	ROUTER		demo-router1
	INTERFACE	demo-router1	demo-subnet1
	GATEWAY		demo-router1	ext-net1

	NET		demo-net2
	SUBNET		demo-net2	demo-subnet2	172.16.1.1	172.16.1.0/24
	ROUTER		demo-router2
	INTERFACE	demo-router2	demo-subnet2
	GATEWAY		demo-router2	ext-net1

	END
