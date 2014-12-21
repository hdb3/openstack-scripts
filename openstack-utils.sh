AND='&&'

function END {
echo "echo 'Finished...'"
}

function ADMINRC {
# echo "source keystone-env.sh $AND"
echo "source admin-openrc.sh $AND"
}

function AUTH {
echo "export OS_SERVICE_TOKEN=\"ADMIN\" $AND"
echo "export OS_SERVICE_ENDPOINT=http://controller:35357/v2.0 $AND"
echo "export OS_AUTH_URL=http://controller:35357/v2.0 $AND"

}

function UNAUTH {
echo "unset OS_SERVICE_TOKEN $AND"
echo "unset OS_SERVICE_ENDPOINT $AND"
}

# keystone tenant-create --name admin --description "Admin Tenant"
# TENANT admin "Admin Tenant"
function COMMAND {
 echo "$* $AND"
}

function TENANT {
 echo "keystone tenant-create --name $1 --description \"$2\" $AND"
}

# keystone user-create --name admin --pass admin --email user@example.com
# USER admin admin user@example.com
function USER {
 echo "keystone user-create --name $1 --pass $2 $AND"
 # echo "keystone user-create --name $1 --pass $2 --email $3"
}

# keystone role-create --name admin
# ROLE admin
function ROLE {
 echo "keystone role-create --name $1 $AND"
}

# keystone user-role-add --tenant admin --user admin --role admin
# ROLE-ADD admin admin admin
function ROLE-ADD {
 echo "keystone user-role-add --user $1 --tenant $2 --role $3 $AND"
}


# keystone service-create --name keystone --type identity --description "OpenStack Identity"
# SERVICE keystone identity "OpenStack Identity"
function SERVICE {
 echo "keystone service-create --name $1 --type $2 --description \"$3\" $AND"
}

# keystone endpoint-create --service-id $(keystone service-list | awk '/ identity / {print $2}') --publicurl http://controller:5000/v2.0 --internalurl http://controller:5000/v2.0 --adminurl http://controller:35357/v2.0 --region regionOne
# ENDPOINT regionOne identity 5000/v2.0 5000/v2.0 35357/v2.0
function ENDPOINT {
ADDR=controller
if [[ $# > 4 ]] ; then
 echo "keystone endpoint-create --service-id \$(keystone service-list | awk '/ $2 / {print \$2}') --publicurl http://${ADDR}:${3} --internalurl http://${ADDR}:${4} --adminurl http://${ADDR}:${5} --region $1 $AND"
else
 echo "keystone endpoint-create --service-id \$(keystone service-list | awk '/ $2 / {print \$2}') --publicurl http://${ADDR}:${3} --internalurl http://${ADDR}:${3} --adminurl http://${ADDR}:${3} --region $1 $AND"
fi

}

# keystone --os-tenant-name admin --os-username admin --os-password admin --os-auth-url http://controller:35357/v2.0 token-get
# KADMIN token-get
function KADMIN {
 echo "keystone --os-tenant-name admin --os-username admin --os-password admin --os-auth-url http://controller:35357/v2.0 $1 $AND"
}

# keystone --os-tenant-name demo --os-username demo --os-password admin --os-auth-url http://controller:35357/v2.0 token-get
# KDEMO token-get
function KDEMO {
 echo "keystone --os-tenant-name demo --os-username demo --os-password admin --os-auth-url http://controller:35357/v2.0 $1 $AND"
}
function KDEMOFAIL {
 echo "keystone --os-tenant-name demo --os-username demo --os-password admin --os-auth-url http://controller:35357/v2.0 $1"
}

# glance image-create --name "cirros-0.3.3-x86_64" --file cirros-0.3.3-x86_64-disk.img --disk-format qcow2 --container-format bare --is-public True --progress
# IMAGE "cirros-0.3.3-x86_64" cirros-0.3.3-x86_64-disk.img qcow2 bare True
function IMAGE {
 echo "glance image-create --name $1 --file $2 --disk-format $3 --container-format $4 --is-public True --progress $AND"
}

# glance image-list
# IMAGE-LIST
function IMAGE-LIST {
 echo "glance image-list $AND"
}

# neutron subnet-create ext-net --name ext-subnet --allocation-pool start=10.0.6.2,end=10.0.6.50 --disable-dhcp --gateway 10.0.6.1 10.0.6.0/24
# SUBNET ext-net ext-subnet --allocation-pool start=10.0.6.2,end=10.0.6.50 --disable-dhcp --gateway 10.0.6.1 10.0.6.0/24
function SUBNET {
if [[ $# > 5 ]] ; then
 echo "neutron subnet-create $1 --name $2 --disable-dhcp --gateway $3 --allocation-pool start=$5,end=$6 $4 $AND"
else
 echo "neutron subnet-create $1 --name $2 --disable-dhcp --gateway $3 $4 $AND"
fi
}

# neutron net-create ext-net --shared --router:external True --provider:physical_network external --provider:network_type flat
# NET ext-net
function EXTNET {
 echo "neutron net-create $1 --shared --router:external True --provider:physical_network external --provider:network_type flat $AND"
}

# NET ext-net
function NET {
 echo "neutron net-create $1 $AND"
}

# neutron router-create demo-router
# ROUTER demo-router
function ROUTER {
 echo "neutron router-create $1 $AND"
}

# neutron router-interface-add demo-router demo-subnet
# INTERFACE demo-router demo-subnet
function INTERFACE {
 echo "neutron router-interface-add $1 $2 $AND"
}

# neutron router-gateway-set demo-router ext-net
# GATEWAY demo-router ext-net
function GATEWAY {
 echo "neutron router-gateway-set $1 $2 $AND"
}
