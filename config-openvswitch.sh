#!bin/bash -e
# sudo ovs-vsctl --may-exist add-br br-ex1
# sudo ovs-vsctl --may-exist add-port br-ex1 $1
# sudo ip link set dev $1 up
sudo ovs-vsctl --may-exist add-br br-vlan
sudo ovs-vsctl --may-exist add-port br-vlan $1 -- set port $1 vlan_mode=trunk trunk=100,101,200,201
sudo ip link set dev $1 up
