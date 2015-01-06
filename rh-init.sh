#!/bin/bash -ev
yum install -y yum-plugin-priorities
yum install -y http://dl.fedoraproject.org/pub/epel/7/x86_64/e/epel-release-7-5.noarch.rpm
yum install -y http://rdo.fedorapeople.org/openstack-juno/rdo-release-juno.rpm
yum upgrade -y
yum install -y `cat yum.list`
sudo sed -i /etc/selinux/config -e 's/enforcing/disabled/'
sudo systemctl disable firewalld
sudo systemctl enable mariadb
sudo systemctl enable openvswitch
sudo systemctl enable rabbitmq-server
sudo systemctl start mariadb
sudo systemctl start openvswitch
sudo systemctl start rabbitmq-server
sudo rabbitmqctl change_password guest admin
mysql_secure_installation
sudo ln -s /etc/neutron/plugins/ml2/ml2_conf.ini /etc/neutron/plugin.ini
sudo sed -i 's,plugins/openvswitch/ovs_neutron_plugin.ini,plugin.ini,g' /usr/lib/systemd/system/neutron-openvswitch-agent.service
sudo chown -R apache:apache /usr/share/openstack-dashboard/static
