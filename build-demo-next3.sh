#!/bin/bash
$( ./set-env.py )
EXBASE=10.30.65
source openstack-utils.sh
set -e
	ADMINRC
for n in 2 3 4
  do
	EXTNET		ext-net${n}		external${n}
	SUBNET		ext-net${n}		ext-subnet${n}	${EXBASE}.1      ${EXBASE}.0/24	${EXBASE}.1${n}0	${EXBASE}.1${n}9
	NET		demo-net${n}
	SUBNET		demo-net${n}	demo-subnet${n}	172.16.0.1	172.16.0.0/12 172.16.0.10 172.16.0.199
	ROUTER		demo-router${n}
	INTERFACE	demo-router${n}	demo-subnet${n}
	GATEWAY		demo-router${n}	ext-net${n}
	COMMAND		"sleep 3"
  done
	END
