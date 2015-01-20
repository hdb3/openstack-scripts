#!/bin/bash -ev
yum upgrade -y
yum install -y `cat yum.list`
for s in `grep -v '^#' rh-core-services` ; do systemctl enable $s ; systemctl start $s ; done
sed -i /etc/selinux/config -e 's/enforcing/disabled/'
systemctl disable NetworkManager
systemctl stop NetworkManager
systemctl disable firewalld
systemctl stop firewalld
rabbitmqctl change_password guest admin
mysql_secure_installation
ln -s /etc/neutron/plugins/ml2/ml2_conf.ini /etc/neutron/plugin.ini
sed -i 's,plugins/openvswitch/ovs_neutron_plugin.ini,plugin.ini,g' /usr/lib/systemd/system/neutron-openvswitch-agent.service
chown -R apache:apache /usr/share/openstack-dashboard/static
