#service lists...

function END {
echo "echo 'Finished...'"
}

function RM {
 echo "sudo rm -f $1"
}

function SU {
 echo "sudo su -s /bin/sh -c '$2' $1"
}

function MYSQL {
    echo "mysql -u $DBUSER --password=$DBPASS -vv -f -e \"$1\""
}

function DB {
MYSQL "DROP DATABASE IF EXISTS $1;"
MYSQL "CREATE DATABASE $1;"
MYSQL "GRANT ALL PRIVILEGES ON $1.* TO '$2'@'localhost'   IDENTIFIED BY '$3';"
MYSQL "GRANT ALL PRIVILEGES ON $1.* TO '$2'@'%'   IDENTIFIED BY '$3';"
}

function _RESTART {
PREFIX=$1
shift
for arg
do
    echo "sudo service ${PREFIX}$arg restart"
done
}

function RESTART {
case $1 in
KEYSTONE) _RESTART ${SERVICE_PREFIX} keystone ;;
GLANCE) _RESTART ${SERVICE_PREFIX} glance-registry glance-api ;;
NOVA) _RESTART ${SERVICE_PREFIX} nova-api nova-cert nova-consoleauth nova-scheduler nova-conductor nova-novncproxy ;;
NEUTRON) _RESTART "" neutron-server nova-api neutron-plugin-openvswitch-agent neutron-l3-agent neutron-dhcp-agent neutron-metadata-agent nova-compute neutron-plugin-openvswitch-agent ;;
CINDER) _RESTART ${SERVICE_PREFIX} cinder-scheduler cinder-api tgt cinder-volume ;;
HEAT) _RESTART ${SERVICE_PREFIX} heat-api heat-api-cfn heat-engine ;;
esac
}
