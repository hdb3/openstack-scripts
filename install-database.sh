
#!/bin/bash

source utils.sh
source openstack-utils.sh
set -e
DBUSER=root
DBPASS=root

  DB keystone keystone admin
  DB glance glance admin
  DB nova nova admin
  DB neutron neutron admin
  DB cinder cinder admin
	END
