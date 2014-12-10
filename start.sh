#!/bin/bash -v
sudo bash openstack.apt.sh
tar zxf content.tgz &&
./build-script.sh &&
./files.py total.txt total.files &&
# ./sql.sh &&
./filter.sh total.txt > total.sh &&
./edit.py total.files  &&
sudo rabbitmqctl change_password guest admin
