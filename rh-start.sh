#!/bin/bash -ev
echo "This installer assumes that the ubuntu cloudstack packages are already installed and up-to-date."
echo "It will look for a customisation script named 'custom.<HOST_NAME>"
#next line should not be neccessary - but.....
sudo systemctl restart rabbitmq-server
sudo rabbitmqctl change_password guest admin
$( ./set-env.py )
./config-openvswitch.sh $EXTERNAL_IF
./edit-conf.sh
sed -e "s/\$MY_IP/$MY_IP/g" < admin-openrc.sh.template > admin-openrc.sh
sed -e "s/\$MY_IP/$MY_IP/g" < demo-openrc.sh.template > demo-openrc.sh
./build-db_sync.sh | bash -ve
./build-openstack.sh | bash -ve
./rh-restart.sh
