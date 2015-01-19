#!/bin/bash
$( ./set-env.py )
source openstack-utils.sh
set -e

	KADMIN		token-get
	ADMINRC
for n in 2 3 4
  do
	EXTNET		ext-net${n}		external${n}
	SUBNET		ext-net${n}		ext-subnet${n}	10.30.65.1      10.30.65.0/24	10.30.65.1${n}0	10.30.65.1${n}9
	NET		demo-net${n}
	SUBNET		demo-net${n}	demo-subnet${n}	172.16.${n}.1	172.16.${n}.0/12
	ROUTER		demo-router${n}
	INTERFACE	demo-router${n}	demo-subnet${n}
	GATEWAY		demo-router${n}	ext-net${n}
	END
  done
