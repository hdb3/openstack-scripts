#!/bin/bash
sudo ovs-vsctl --may-exist add-br br-ex
sudo ovs-vsctl --may-exist add-port br-ex $1
