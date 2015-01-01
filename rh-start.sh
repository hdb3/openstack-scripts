#!/bin/bash -ev
echo "This installer assumes that the ubuntu cloudstack packages are already installed and up-to-date."
echo "It will look for a customisation script named 'custom.<HOST_NAME>"
# sudo ./remove-upstart-overrides.sh # only needed in Ubuntu - use systemctl enable in RH
$( ./set-env.py )
./config-openvswitch.sh $EXTERNAL_IF
./edit-conf.sh
sed -e "s/\$MY_IP/$MY_IP/g" < admin-openrc.sh.template > admin-openrc.sh
sed -e "s/\$MY_IP/$MY_IP/g" < demo-openrc.sh.template > demo-openrc.sh
./build-db_sync.sh | bash -ve
# ./service-restart.sh KEYSTONE | bash -ve
./restart.sh
! read -t 2 -i "allow keystone to start"
./keystone-setup.sh | bash -ve
./update-neutron-conf.sh
./service-restart.sh NEUTRON | bash -ve
./build-openstack.sh | bash -ve
./restart.sh
