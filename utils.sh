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
      unset args
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
    echo "mysql -u $DBUSER --password=$DBPASS -f -e \"$1\""
    # echo "mysql -u $DBUSER --password=$DBPASS -vv -f -e \"$1\""
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
NOVA_SERVICES="nova-api nova-cert nova-consoleauth nova-scheduler nova-conductor nova-novncproxy nova-compute"
NEUTRON_SERVICES="neutron-server neutron-l3-agent neutron-dhcp-agent neutron-metadata-agent"
case ${OS_ENV} in
DEB) NEUTRON_SERVICES="$NEUTRON_SERVICES neutron-plugin-openvswitch-agent" ;;
YUM) NEUTRON_SERVICES="$NEUTRON_SERVICES neutron-openvswitch-agent" ;;
esac

CINDER_SERVICES="cinder-scheduler cinder-api cinder-volume"
HEAT_SERVICES="heat-api heat-api-cfn heat-engine"
CEILOMETER_SERVICES="ceilometer-agent-central ceilometer-agent-compute ceilometer-agent-notification ceilometer-alarm-evaluator ceilometer-alarm-notifier ceilometer-api ceilometer-collector"


ALL="KEYSTONE NOVA NEUTRON GLANCE CINDER HEAT CEILOMETER"
function RESTART {
  for arg
    do
       SERVICES="${arg}_SERVICES"
      _RESTART "${!SERVICES}"
    done
}

function RESTART_ALL {
    RESTART $ALL
}
