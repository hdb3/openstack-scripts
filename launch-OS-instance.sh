FLAVOR=m1.tiny
NET=demo-net
EXTNET=ext-net
NAME=srvrX
IMAGE=cirros
SECGRP=default
KEY=kEy
ZONE=nova
COUNT=$1

IMAGE_ID=$( nova image-list | awk -e " /$IMAGE/ { print \$2 }")
NET_ID=$( neutron net-list | awk -e " /$NET/ { print \$2 }")
nova keypair-add kEy --pub-key ~/.ssh/id_rsa.pub
echo "launching $IMAGE_ID on net $NET_ID with flavour $FLAVOR as $NAME"
echo "nova boot --poll --flavor $FLAVOR --image $IMAGE_ID --security-groups $SECGRP --key-name $KEY --availability-zone $ZONE --nic net-id=$NET_ID --min-count $COUNT $NAME"
nova boot --poll --flavor $FLAVOR --image $IMAGE_ID --security-groups $SECGRP --key-name $KEY --availability-zone $ZONE --nic net-id=$NET_ID --min-count $COUNT $NAME
