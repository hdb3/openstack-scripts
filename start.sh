#!/bin/bash -v
echo "This installer assumes that the ubuntu cloudstack packages are already installed and up-to-date."
echo "It will look for a customisation script named 'custom.<HOST_NAME>"
read -t 10 -n 1 c
./set-env.py | bash &&
sudo ./check-dns.sh $MY_IP $DB_IP &&
source address-fix-template.sh $MY_IP > /tmp/address-fix.files &&
./address-fix.sh /tmp/address-fix.files &&
sudo service mysql restart &&
# sudo bash openstack.apt.sh &&
tar zxf content.tgz &&
./build-script.sh &&
# ./files.py total.txt total.files &&
./files.py total.txt | sed -e "/bind-address/ s/10.0.0.11/$DB_IP/g ; s/10.0.0.11/$MY_IP/g" > total.files &&
# ./sql.sh &&
./filter.sh total.txt > total.sh &&
sudo ./edit.py -v total.files  &&
sudo ./edit.py -w total.files  &&
sudo rabbitmqctl change_password guest admin &&
./config-openvswitch.sh $EXTERNAL_IF &&
./lvm.sh &&
./build-db_sync.sh | bash -v &&
./build-openstack.sh | bash -v &&
./build-restart.sh | bash -v
