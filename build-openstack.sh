#!/bin/bash
source openstack-utils.sh
set -e

        AUTH
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
	COMMAND		"./update-neutron-conf.sh"

	SERVICE		keystone	identity	"OpenStack Identity"
	ENDPOINT	regionOne	identity	"5000/v2.0"	"5000/v2.0"	"35357/v2.0"

#verification..
	UNAUTH
	KADMIN		token-get
	KADMIN		tenant-list
	KADMIN		user-list
	KADMIN		role-list

#verification..

	KDEMO		token-get
	KDEMO		user-list
	KADMIN		token-get
	KADMIN		tenant-list
	KADMIN		user-list
	KADMIN		role-list
	KDEMO		token-get
	KDEMOFAIL		user-list
	KADMIN		token-get
        AUTH

	ADMINRC
	USER		glance	admin
	ROLE-ADD	glance	service	admin
	SERVICE		glance	image	"OpenStack Image Service"
	ENDPOINT	regionOne	image	9292
	#COMMAND		"wget http://cdn.download.cirros-cloud.net/0.3.3/cirros-0.3.3-x86_64-disk.img"
	#IMAGE		"cirros-0.3.3-x86_64"	cirros-0.3.3-x86_64-disk.img	qcow2	bare	True
	IMAGE		"Fedora-x86_64-20-20140618"	../Fedora-x86_64-20-20140618-sda.qcow2	qcow2	bare	True
	NETIMAGE	"cirros-0.3.3-x86_64"		"http://cdn.download.cirros-cloud.net/0.3.3/cirros-0.3.3-x86_64-disk.img"				qcow2	bare	True
	#NETIMAGE	"Fedora-x86_64-20-20140618"	"https://download.fedoraproject.org/pub/alt/openstack/20/x86_64/Fedora-x86_64-20-20140618-sda.qcow2"	qcow2	bare    True
	IMAGE-LIST

	USER		nova	admin
	ROLE-ADD	nova	service	admin
	SERVICE		nova	compute	"OpenStack Compute"
	ENDPOINT	regionOne	compute	"8774/v2/%\(tenant_id\)s"

	USER		neutron	admin
	ROLE-ADD	neutron	service	admin
	SERVICE		neutron	network	"OpenStack Networking"
	ENDPOINT	regionOne	network	9696
	COMMAND		"keystone tenant-get	service"
	COMMAND		"neutron	ext-list"
	EXTNET		ext-net
	#		network name	subnet name	gateway		CIDR		alloc start	alloc end
	#  SUBNET	ext-net		ext-subnet	10.30.65.1      10.30.65.0/24	10.30.65.2	10.30.65.50
	SUBNET	ext-net		ext-subnet	192.168.1.254      192.168.1.0/24	192.168.1.220	192.168.1.239
	NET		demo-net
	SUBNET		demo-net	demo-subnet	172.16.0.1	172.16.0.0/12
	ROUTER		demo-router
	INTERFACE	demo-router	demo-subnet
	GATEWAY		demo-router	ext-net
	USER		cinder	admin
	ROLE-ADD	cinder	service	admin
	SERVICE		cinder	volume	"OpenStack Block Storage"
	SERVICE		cinderv2	volumev2	"OpenStack Block Storage"
	ENDPOINT	regionOne	volume	"8776/v1/%\(tenant_id\)s"
	ENDPOINT	regionOne	volumev2	"8776/v2/%\(tenant_id\)s"
	COMMAND		"cinder		create	--display-name	demo-volume1	1"
	USER		heat	admin
	ROLE-ADD	heat	service	admin
	ROLE		heat_stack_user
	ROLE		heat_stack_owner
	SERVICE		heat	orchestration	"Orchestration"
	SERVICE		heat-cfn	cloudformation	"Orchestration"
	ENDPOINT	regionOne	orchestration	"8004/v1/%\(tenant_id\)s"
	ENDPOINT	regionOne	cloudformation	"8000/v1"
	COMMAND		"NET_ID=\$(neutron	net-list	|	awk	'/	demo-net	/	{	print	\$2	}')"
	COMMAND		"heat		stack-create	-f	test-stack.yml	-P	\"ImageID=cirros-0.3.3-x86_64;NetID=\$NET_ID\"	testStack"
	USER		ceilometer	admin
	ROLE-ADD	ceilometer	service	admin
	SERVICE		ceilometer	metering	"Telemetry"
	ENDPOINT	regionOne	metering	8777
	END
