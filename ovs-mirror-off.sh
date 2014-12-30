#!/bin/bash -v
bridge=$1
sudo ovs-vsctl clear bridge $bridge mirrors
sudo ovs-vsctl del-port $bridge dummy0
sudo ip link del dev dummy0
