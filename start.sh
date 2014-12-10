#!/bin/bash -v
sudo bash openstack.apt.sh &&
tar zxf content.tgz &&
./build-script.sh &&
./files.py total.txt total.files &&
# ./sql.sh &&
./filter.sh total.txt > total.sh &&
sudo ./edit.py -w total.files  &&
sudo service mysql restart &&
sudo rabbitmqctl change_password guest admin &&
./db_sync.sh > db.sh &&
source db.sh &&
./openstack.sh > os.sh &&
sh -v os.sh
