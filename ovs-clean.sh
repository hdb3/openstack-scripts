for br in `ovs-vsctl list-br`
  do
    echo "cleaning $br"
    ovs-vsctl del-br $br
    ovs-vsctl add-br $br
  done
