#!/bin/bash

sudo ip link add dummy0 type dummy
sudo ip link set link dev dummy0 up
sudo ovs-vsctl add-port $1 dummy0 \
           -- --id=@p get port dummy0 \
	   -- --id=@m create mirror name=m0 select-all=true select-vlan=$2 output-port=@p \
	   -- set bridge $1 mirrors=@m
echo "success - you may now monitor port 'dummy0' to see traffic from bridge '$1'/ vlan '$2'"
echo "clear this mirror using the scrip ovs-mirror-off.sh or the command 'ovs-vsctl clear bridge $1 mirrors'"
