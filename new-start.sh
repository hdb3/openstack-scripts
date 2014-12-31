#!/bin/bash -ev
echo "This installer assumes that the ubuntu cloudstack packages are already installed and up-to-date."
echo "It will look for a customisation script named 'custom.<HOST_NAME>"
./stop.sh
$( ./set-env.py )
# sudo ./check-dns.sh $MY_IP $DB_IP
# source address-fix-template.sh $MY_IP | sudo ./edit.py -w -v
./edit-conf.sh
sudo rabbitmqctl start_app
sudo rabbitmqctl change_password guest admin
# sudo ./check-dns.sh $MY_IP $DB_IP
./config-openvswitch.sh $EXTERNAL_IF
# ./lvm.sh
sed -e "s/\$MY_IP/$MY_IP/g" < admin-openrc.sh.template > admin-openrc.sh
sed -e "s/\$MY_IP/$MY_IP/g" < demo-openrc.sh.template > demo-openrc.sh
./build-db_sync.sh | bash -ve
./build-openstack.sh | bash -ve
./restart.sh
