#!/bin/bash -e
conf_file=/etc/neutron/neutron.conf
source admin-openrc.sh
SERVICE_TENANT_ID=`keystone tenant-list | awk '/ service / {print $2}'`
echo "The SERVICE_TENANT_ID is $SERVICE_TENANT_ID"
echo "updating $conf_file"
sudo sed -i.bak -e "s/^nova_admin_tenant_id.*$/nova_admin_tenant_id = $SERVICE_TENANT_ID/" $conf_file
sudo chown --reference ${conf_file}.bak $conf_file
