#service lists...
if [[ "XXX" == "XXX${OS_ENV}" ]]
  then
    echo "oops, \$OS_ENV not set, can't continue ($0)"
    exit 1
fi

case ${OS_ENV} in

DEB)
    function _service {
      cmd=$1 ; shift
      for arg
      do
        echo "sudo service $arg $cmd"
      done
    } ;;

YUM)
    function _service {
      cmd=$1 ; shift
      for arg
      do
        if [[ $arg == neutron* ]]
        then
          args="$args $arg"
        else
          args="$args openstack-${arg}"
        fi
      done
      echo "sudo systemctl $cmd $args"
    } ;;

*  ) echo "oops, unknown setting for \$OS_ENV not set, can't continue ($OS_ENV)"
     exit 1 ;;

esac

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
    _service restart $@
}

KEYSTONE_SERVICES="keystone"
GLANCE_SERVICES="glance-registry glance-api"
NOVA_SERVICES="nova-api nova-cert nova-consoleauth nova-scheduler nova-conductor nova-novncproxy"
NEUTRON_SERVICES="neutron-server neutron-plugin-openvswitch-agent neutron-l3-agent neutron-dhcp-agent neutron-metadata-agent neutron-plugin-openvswitch-agent"
CINDER_SERVICES="cinder-scheduler cinder-api tgt cinder-volume"
HEAT_SERVICES="heat-api heat-api-cfn heat-engine"

ALL="NOVA NEUTRON GLANCE CINDER HEAT"
function RESTART {
  for arg
    do
       SERVICES="${arg}_SERVICES"
      _RESTART "${!SERVICES}"
    done
}
