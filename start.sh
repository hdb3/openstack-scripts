#!/bin/bash -v
echo "This installer assumes that the ubuntu cloudstack packages are already installed and up-to-date."
read -t 10 -n 1 c
source custom.sh &&
# sudo bash openstack.apt.sh &&
tar zxf content.tgz &&
./build-script.sh &&
./files.py total.txt total.files &&
# ./sql.sh &&
./filter.sh total.txt > total.sh &&
sudo ./edit.py -v total.files  &&
sudo ./edit.py -w total.files  &&
./address-fix.sh &&
sudo service mysql restart &&
sudo rabbitmqctl change_password guest admin &&
sudo ./check-dns.sh &&
./config-openvswitch.sh $EXTERNAL_IF &&
./lvm.sh
./build-db_sync.sh > db_sync &&
source db_sync &&
./build-openstack.sh > openstack &&
source openstack &&
./build-restart.sh > restart &&
source ./restart
