#!/bin/bash -ev
yum install -y yum-plugin-priorities
yum install -y http://dl.fedoraproject.org/pub/epel/7/x86_64/e/epel-release-7-5.noarch.rpm
yum install -y http://rdo.fedorapeople.org/openstack-juno/rdo-release-juno.rpm
yum upgrade -y
yum install -y `cat yum.list`
sudo systemctl restart rabbitmq-server
read -t 10 -i "pausing to allow the rabbit to settle"
sudo rabbitmqctl change_password guest admin
sudo ln -s /etc/neutron/plugins/ml2/ml2_conf.ini /etc/neutron/plugin.ini
