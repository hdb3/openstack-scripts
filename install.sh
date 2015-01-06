
#!/bin/bash

source utils.sh
source openstack-utils.sh
set -e
DBUSER=root
DBPASS=root

# KEYSTONE
  DB keystone keystone admin
  SU keystone "keystone-manage db_sync"
  RESTART KEYSTONE
  WAIT 2 "allow keystone to settle"

  TOKEN_AUTH
  TENANT		admin	"Admin Tenant"
  USER		admin	admin	user@example.com
  ROLE		admin
  ROLE-ADD	admin	admin	admin
  ROLE		_member_
  ROLE-ADD	admin	admin	_member_
  TENANT		demo	"Demo	Tenant"
  USER		demo	admin	user@example.com
  ROLE-ADD	demo	demo	_member_
  TENANT		service	"Service Tenant"

  SERVICE		keystone	identity	"OpenStack Identity"
  ENDPOINT	regionOne	identity	"5000/v2.0"	"5000/v2.0"	"35357/v2.0"
  TOKEN_UNAUTH

  ADMINRC
  KADMIN		token-get

# GLANCE
  DB glance glance admin

  USER		glance	admin
  ROLE-ADD	glance	service	admin
  SERVICE		glance	image	"OpenStack Image Service"
  ENDPOINT	regionOne	image	9292

  SU glance "glance-manage db_sync"
  RESTART GLANCE

# NOVA
  DB nova nova admin

  USER		nova	admin
  ROLE-ADD	nova	service	admin
  SERVICE		nova	compute	"OpenStack Compute"
  ENDPOINT	regionOne	compute	"8774/v2/%\(tenant_id\)s"

  SU nova "nova-manage db sync"
  WAIT 2 "allow nova to settle"
  RESTART NOVA

# NEUTRON
  DB neutron neutron admin

  USER		neutron	admin
  ROLE-ADD	neutron	service	admin
  SERVICE		neutron	network	"OpenStack Networking"
  ENDPOINT	regionOne	network	9696

  COMMAND		"./update-neutron-conf.sh"
  SU neutron "neutron-db-manage --config-file /etc/neutron/neutron.conf --config-file /etc/neutron/plugins/ml2/ml2_conf.ini upgrade juno"
  WAIT 2 "allow nova to settle"
  RESTART NOVA
  RESTART NEUTRON

# CINDER
  DB cinder cinder admin

  USER		cinder	admin
  ROLE-ADD	cinder	service	admin
  SERVICE		cinder	volume	"OpenStack Block Storage"
  SERVICE		cinderv2	volumev2	"OpenStack Block Storage"
  ENDPOINT	regionOne	volume	"8776/v1/%\(tenant_id\)s"
  ENDPOINT	regionOne	volumev2	"8776/v2/%\(tenant_id\)s"

  SU cinder "cinder-manage db sync"
  RESTART CINDER

# HEAT
  DB heat heat admin

  USER		heat	admin
  ROLE-ADD	heat	service	admin
  ROLE		heat_stack_user
  ROLE		heat_stack_owner
  SERVICE		heat	orchestration	"Orchestration"
  SERVICE		heat-cfn	cloudformation	"Orchestration"
  ENDPOINT	regionOne	orchestration	"8004/v1/%\(tenant_id\)s"
  ENDPOINT	regionOne	cloudformation	"8000/v1"

  SU heat "heat-manage db_sync"
  RESTART HEAT

  # USER		ceilometer	admin
  # ROLE-ADD	ceilometer	service	admin
  # SERVICE		ceilometer	metering	"Telemetry"
  # ENDPOINT	regionOne	metering	8777
	END
