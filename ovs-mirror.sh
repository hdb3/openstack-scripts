#!/bin/bash -ve

sudo ip link add veth0 type veth peer name veth1
sudo ip link set link dev veth0 up
sudo ip link set link dev veth1 up
sudo ovs-vsctl add-port $1 veth0 \
           -- --id=@p get port veth0 \
	   -- --id=@m create mirror name=m0 select-all=true select-vlan=$2 output-port=@p \
	   -- set bridge $1 mirrors=@m
