FLAVOR=m1.tiny
NET=demo-net
EXTNET=ext-net
NAME=srvrX
IMAGE=cirros
SECGRP=default
KEY=acer
ZONE=nova
COUNT=3

function add_ips {
for arg
do
  echo "nova floating-ip-create $EXTNET"
  IP=$( nova floating-ip-create $EXTNET | awk ' / - / {print $2}' )
  echo "nova floating-ip-associate $arg $IP"
  nova floating-ip-associate $arg $IP
done
}

IMAGE_ID=$( nova image-list | awk -e " /$IMAGE/ { print \$2 }")
NET_ID=$( neutron net-list | awk -e " /$NET/ { print \$2 }")
echo "launching $IMAGE_ID on net $NET_ID with flavour $FLAVOR as $NAME"
echo "nova boot --poll --flavor $FLAVOR --image $IMAGE_ID --security-groups $SECGRP --key-name $KEY --availability-zone $ZONE --nic net-id=$NET_ID --min-count $COUNT $NAME"
nova boot --poll --flavor $FLAVOR --image $IMAGE_ID --security-groups $SECGRP --key-name $KEY --availability-zone $ZONE --nic net-id=$NET_ID --min-count $COUNT $NAME
add_ips $( nova list | awk -e " /${NAME}.*ACTIVE/ {print \$2}" )
