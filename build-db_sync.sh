#!/bin/bash

source utils.sh
set -e
DBUSER=root
DBPASS=root

# KEYSTONE
 DB keystone keystone admin
 SU keystone "keystone-manage db_sync"
 # RESTART KEYSTONE

# GLANCE
 DB glance glance admin
 SU glance "glance-manage db_sync"
 # RESTART GLANCE

# NOVA
 DB nova nova admin
 SU nova "nova-manage db sync"
 # RESTART NOVA

# NEUTRON
 DB neutron neutron admin
 SU neutron "neutron-db-manage --config-file /etc/neutron/neutron.conf --config-file /etc/neutron/plugins/ml2/ml2_conf.ini upgrade juno"
 # RESTART NOVA
 # RESTART NEUTRON

# CINDER
 DB cinder cinder admin
 SU cinder "cinder-manage db sync"
 # RESTART CINDER

# HEAT
 DB heat heat admin
 SU heat "heat-manage db_sync"
 # RESTART HEAT

 END
