#!/bin/bash -ev
yum install -y yum-plugin-priorities
yum install -y epel-release
yum install -y http://rdo.fedorapeople.org/openstack-juno/rdo-release-juno.rpm
yum upgrade -y
yum install -y `cat yum.list`
for s in `grep -v '^#' rh-core-services` ; do systemctl enable $s ; systemctl start $s ; done
sed -i /etc/selinux/config -e 's/enforcing/disabled/'
ln -s /etc/neutron/plugins/ml2/ml2_conf.ini /etc/neutron/plugin.ini
sed -i 's,plugins/openvswitch/ovs_neutron_plugin.ini,plugin.ini,g' /usr/lib/systemd/system/neutron-openvswitch-agent.service
chown -R apache:apache /usr/share/openstack-dashboard/static
systemctl disable NetworkManager firewalld
systemctl stop NetworkManager firewalld
rabbitmqctl change_password guest admin
echo "please coose password 'root' when prompted (there is no existing password)"
mysql_secure_installation
