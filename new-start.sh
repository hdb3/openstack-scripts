echo "This installer assumes that the ubuntu cloudstack packages are already installed and up-to-date."
echo "It will look for a customisation script named 'custom.<HOST_NAME>"
read -t 10 -n 1 c
$( ./set-env.py )
sudo bash -ve edit-conf.sh
sudo rabbitmqctl change_password guest admin
# sudo ./check-dns.sh $MY_IP $DB_IP
sudo bash -ve config-openvswitch.sh $EXTERNAL_IF
# ./lvm.sh
./build-db_sync.sh | bash -ve
./build-openstack.sh | bash -ve
