#!/bin/bash -e
sudo ovs-vsctl --may-exist add-br br-ex
sudo ovs-vsctl --may-exist add-port br-ex $1
sudo ip link set dev $1 up
