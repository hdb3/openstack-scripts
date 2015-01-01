#!/bin/bash
source openstack-utils.sh
set -e

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
	USER		glance	admin
	ROLE-ADD	glance	service	admin
	SERVICE		glance	image	"OpenStack Image Service"
	ENDPOINT	regionOne	image	9292

	USER		nova	admin
	ROLE-ADD	nova	service	admin
	SERVICE		nova	compute	"OpenStack Compute"
	ENDPOINT	regionOne	compute	"8774/v2/%\(tenant_id\)s"

	USER		neutron	admin
	ROLE-ADD	neutron	service	admin
	SERVICE		neutron	network	"OpenStack Networking"
	ENDPOINT	regionOne	network	9696

	USER		cinder	admin
	ROLE-ADD	cinder	service	admin
	SERVICE		cinder	volume	"OpenStack Block Storage"
	SERVICE		cinderv2	volumev2	"OpenStack Block Storage"
	ENDPOINT	regionOne	volume	"8776/v1/%\(tenant_id\)s"
	ENDPOINT	regionOne	volumev2	"8776/v2/%\(tenant_id\)s"

	USER		heat	admin
	ROLE-ADD	heat	service	admin
	ROLE		heat_stack_user
	ROLE		heat_stack_owner
	SERVICE		heat	orchestration	"Orchestration"
	SERVICE		heat-cfn	cloudformation	"Orchestration"
	ENDPOINT	regionOne	orchestration	"8004/v1/%\(tenant_id\)s"
	ENDPOINT	regionOne	cloudformation	"8000/v1"

	USER		ceilometer	admin
	ROLE-ADD	ceilometer	service	admin
	SERVICE		ceilometer	metering	"Telemetry"
	ENDPOINT	regionOne	metering	8777
	END
