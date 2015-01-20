#!/bin/bash -e
n=1
for interface in `echo $1 | tr ':' ' '`
do
  echo "processing interface $n:$interface"
  sudo ovs-vsctl --may-exist add-br br-ex${n}
  sudo ovs-vsctl --may-exist add-port br-ex${n} $interface
  sudo ip link set dev $interface up
  let n=n+1
done
