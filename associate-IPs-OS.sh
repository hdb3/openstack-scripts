EXTNET=ext-net
NAME=srvrX

function add_ips {
for arg
do
  echo "nova floating-ip-create $EXTNET"
  IP=$( nova floating-ip-create $EXTNET | awk ' / - / {print $2}' )
  echo "nova floating-ip-associate $arg $IP"
  nova floating-ip-associate $arg $IP
done
}

add_ips $( nova list | awk -e " /${NAME}.*ACTIVE/ {print \$2}" )
