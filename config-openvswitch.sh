#!/bin/bash -e
sudo ovs-vsctl --may-exist add-br br-ex1
sudo ovs-vsctl --may-exist add-port br-ex1 $1
sudo ip link set dev $1 up
