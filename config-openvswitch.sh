#!/bin/bash -e
n=1
for interface in `echo $1 | tr ':' ' '`
do
  echo "processing interface $n:$interface"
  if [ $n -eq 1 ]
  then
    mappings="bridge_mappings = external1:br-ex1"
    vlans="network_vlan_ranges = external1"
  else
    mappings="${mappings},external${n}:br-ex${n}"
    vlans="${vlans},externa${n}1"
  fi
  sudo ovs-vsctl --may-exist add-br br-ex${n}
  sudo ovs-vsctl --may-exist add-port br-ex${n} $interface
  sudo ip link set dev $interface up
  let n=n+1
done
echo "[ovs]"                        > os.neutron-bridge-mappings
echo "${mappings}"                 >> os.neutron-bridge-mappings
echo "${vlans}"                    >> os.neutron-bridge-mappings
