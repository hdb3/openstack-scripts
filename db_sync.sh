#!/bin/bash

source utils.sh
DBUSER=root
DBPASS=root

# KEYSTONE
 DB keystone keystone admin
 SU keystone "keystone-manage db_sync"
 RESTART keystone
 RM /var/lib/keystone/keystone.db

# GLANCE
 DB keystone keystone admin
 SU glance "glance-manage db_sync"
 RESTART glance-registry glance-api

# NEUTRON/NOVA
 DB neutron neutron admin
 SU neutron "neutron-db-manage --config-file /etc/neutron/neutron.conf   --config-file /etc/neutron/plugins/ml2/ml2_conf.ini upgrade juno"
 RESTART nova-api nova-scheduler nova-conductor neutron-server nova-api -switch neutron-plugin-openvswitch-agent neutron-l3-agent neutron-dhcp-agent neutron-metadata-agent -switch nova-compute neutron-plugin-openvswitch-agent

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

# MYSQL "CREATE DATABASE keystone;"
# MYSQL "GRANT ALL PRIVILEGES ON keystone.* TO 'keystone'@'localhost'   IDENTIFIED BY 'admin';"
# MYSQL "GRANT ALL PRIVILEGES ON keystone.* TO 'keystone'@'%'   IDENTIFIED BY 'admin';"
# MYSQL "CREATE DATABASE glance;"
# MYSQL "GRANT ALL PRIVILEGES ON glance.* TO 'glance'@'localhost'   IDENTIFIED BY 'admin';"
# MYSQL "GRANT ALL PRIVILEGES ON glance.* TO 'glance'@'%'   IDENTIFIED BY 'admin';"
# MYSQL "CREATE DATABASE neutron;"
# MYSQL "GRANT ALL PRIVILEGES ON neutron.* TO 'neutron'@'localhost'   IDENTIFIED BY 'admin';"
# MYSQL "GRANT ALL PRIVILEGES ON neutron.* TO 'neutron'@'%'   IDENTIFIED BY 'admin';"
# MYSQL "CREATE DATABASE cinder;"
# MYSQL "GRANT ALL PRIVILEGES ON cinder.* TO 'cinder'@'localhost'   IDENTIFIED BY 'admin';"
# MYSQL "GRANT ALL PRIVILEGES ON cinder.* TO 'cinder'@'%'   IDENTIFIED BY 'admin';"
# MYSQL "CREATE DATABASE heat;"
# MYSQL "GRANT ALL PRIVILEGES ON heat.* TO 'heat'@'localhost'   IDENTIFIED BY 'admin';"
# MYSQL "GRANT ALL PRIVILEGES ON heat.* TO 'heat'@'%'   IDENTIFIED BY 'admin';"

