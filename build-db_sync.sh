#!/bin/bash

source utils.sh
set -e
DBUSER=root
DBPASS=root

# KEYSTONE
 DB keystone keystone admin
 SU keystone "keystone-manage db_sync"
 RESTART keystone
 RM /var/lib/keystone/keystone.db

# GLANCE
 DB glance glance admin
 SU glance "glance-manage db_sync"
 RESTART glance-registry glance-api

# NOVA
 DB nova nova admin
 SU nova "nova-manage db sync"
 RESTART nova-api nova-cert nova-consoleauth nova-scheduler nova-conductor nova-novncproxy

# NEUTRON
 DB neutron neutron admin
 SU neutron "neutron-db-manage --config-file /etc/neutron/neutron.conf --config-file /etc/neutron/plugins/ml2/ml2_conf.ini upgrade juno"
 RESTART nova-api nova-scheduler nova-conductor neutron-server nova-api neutron-plugin-openvswitch-agent neutron-l3-agent neutron-dhcp-agent neutron-metadata-agent nova-compute neutron-plugin-openvswitch-agent

# CINDER
 DB cinder cinder admin
 SU cinder "cinder-manage db sync"
 RESTART cinder-scheduler cinder-api tgt cinder-volume
 RM /var/lib/cinder/cinder.sqlite

# HEAT
 DB heat heat admin
 SU heat "heat-manage db_sync"
 RESTART heat-api heat-api-cfn heat-engine
 RM /var/lib/heat/heat.sqlite

 END




