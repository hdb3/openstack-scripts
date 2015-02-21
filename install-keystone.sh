
#!/bin/bash

source utils.sh
source openstack-utils.sh
set -e
# DBUSER=root
# DBPASS=root

# KEYSTONE
  SU keystone "keystone-manage db_sync"
  RESTART KEYSTONE
  # WAIT 2 "allow keystone to settle"

  TOKEN_AUTH
  TENANT                admin   "Admin Tenant"
  USER          admin   admin   user@example.com
  ROLE          admin
  ROLE-ADD      admin   admin   admin
  ROLE          _member_
  ROLE-ADD      admin   admin   _member_

  TENANT		service	"Service Tenant"
  SERVICE		keystone	identity	"OpenStack Identity"
  ENDPOINT	regionOne	identity	"5000/v2.0"	"5000/v2.0"	"35357/v2.0"
  TOKEN_UNAUTH

  ADMINRC

# GLANCE

  USER		glance	admin
  ROLE-ADD	glance	service	admin
  SERVICE		glance	image	"OpenStack Image Service"
  ENDPOINT	regionOne	image	9292

# NOVA

  USER		nova	admin
  ROLE-ADD	nova	service	admin
  SERVICE		nova	compute	"OpenStack Compute"
  ENDPOINT	regionOne	compute	"8774/v2/%\(tenant_id\)s"

# NEUTRON

  USER		neutron	admin
  ROLE-ADD	neutron	service	admin
  SERVICE		neutron	network	"OpenStack Networking"
  ENDPOINT	regionOne	network	9696

# CINDER

  USER		cinder	admin
  ROLE-ADD	cinder	service	admin
  SERVICE		cinder	volume	"OpenStack Block Storage"
  SERVICE		cinderv2	volumev2	"OpenStack Block Storage"
  ENDPOINT	regionOne	volume	"8776/v1/%\(tenant_id\)s"
  ENDPOINT	regionOne	volumev2	"8776/v2/%\(tenant_id\)s"

	END
