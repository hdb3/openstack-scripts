#!/bin/bash -ev
echo "This installer assumes that the ubuntu cloudstack packages are already installed and up-to-date."
echo "It will look for a customisation script named 'custom.<HOST_NAME>"
#next line should not be neccessary - but.....
sudo systemctl restart rabbitmq-server
read -t 10 -i "pausing to allow the rabbit to settle"
sudo rabbitmqctl change_password guest admin
$( ./set-env.py )
./config-openvswitch.sh $EXTERNAL_IF
sudo ln -s /etc/neutron/plugins/ml2/ml2_conf.ini /etc/neutron/plugin.ini
./edit-conf.sh
sed -e "s/\$MY_IP/$MY_IP/g" < admin-openrc.sh.template > admin-openrc.sh
sed -e "s/\$MY_IP/$MY_IP/g" < demo-openrc.sh.template > demo-openrc.sh
./build-db_sync.sh | bash -ve
./service-restart.sh KEYSTONE
./keystone-setup.sh | bash -ve
./update-neutron-conf.sh
./service-restart.sh
./build-openstack.sh | bash -ve
