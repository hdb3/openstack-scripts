#!/bin/bash -v
echo "This installer assumes that the ubuntu cloudstack packages are already installed and up-to-date."
read -t 10 -n 1 c
source custom.sh &&
source address-fix.template.sh $MY_IP > /tmp/address-fix.files &&
./address-fix.sh /tmp/address-fix.files &&
sudo service mysql restart &&
# sudo bash openstack.apt.sh &&
tar zxf content.tgz &&
./build-script.sh &&
./files.py total.txt total.files &&
# ./sql.sh &&
./filter.sh total.txt > total.sh &&
sudo ./edit.py -v total.files  &&
sudo ./edit.py -w total.files  &&
sudo rabbitmqctl change_password guest admin &&
sudo ./check-dns.sh $MY_IP $DB_IP &&
./config-openvswitch.sh $EXTERNAL_IF &&
./lvm.sh
./build-db_sync.sh | bash -v &&
./build-openstack.sh | bash -v &&
./build-restart.sh | bash -v
