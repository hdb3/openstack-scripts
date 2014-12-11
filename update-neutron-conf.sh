#!/bin/bash
source admin-openrc.sh 
SERVICE_TENANT_ID=`keystone tenant-list | awk '/ service / {print $2}'`
echo "The ID is $SERVICE_TENANT_ID"
echo "{/etc/neutron/neutron.conf}" > neutron.conf
echo "[DEFAULT]" >> neutron.conf
echo "nova_admin_tenant_id = $SERVICE_TENANT_ID" >> neutron.conf
sudo ./edit.py -v -w neutron.conf
