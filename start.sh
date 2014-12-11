#!/bin/bash -v
echo "This installer assumes that the ubuntu cloudstack packages are already installed and up-to-date."
read -t 10 -n 1 c
# sudo bash openstack.apt.sh &&
tar zxf content.tgz &&
./build-script.sh &&
./files.py total.txt total.files &&
# ./sql.sh &&
./filter.sh total.txt > total.sh &&
sudo ./edit.py -w total.files  &&
./address-fix.sh &&
sudo service mysql restart &&
sudo rabbitmqctl change_password guest admin &&
./openswitch.sh
./lvm.sh
./build-db_sync.sh > db_sync &&
source db_sync &&
./build-openstack.sh > openstack &&
source openstack &&
neutron subnet-update demo-subnet --enable_dhcp True &&
./build-restart.sh > restart &&
source restart
