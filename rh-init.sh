#!/bin/bash -ev
yum install -y yum-plugin-priorities
yum install -y http://dl.fedoraproject.org/pub/epel/7/x86_64/e/epel-release-7-5.noarch.rpm
yum install -y http://rdo.fedorapeople.org/openstack-juno/rdo-release-juno.rpm
yum upgrade -y
yum install -y `cat yum.list`
sed -i /etc/selinux/config -e 's/enforcing/disabled/'
systemctl disable firewalld
systemctl enable mariadb
systemctl enable openvswitch
systemctl enable rabbitmq-server
systemctl start mariadb
systemctl start openvswitch
systemctl start rabbitmq-server
rabbitmqctl change_password guest admin
mysql_secure_installation
ln -s /etc/neutron/plugins/ml2/ml2_conf.ini /etc/neutron/plugin.ini
sed -i 's,plugins/openvswitch/ovs_neutron_plugin.ini,plugin.ini,g' /usr/lib/systemd/system/neutron-openvswitch-agent.service
chown -R apache:apache /usr/share/openstack-dashboard/static
