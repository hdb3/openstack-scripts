#!/bin/bash

source utils.sh
set -e
 RESTART keystone

 RESTART glance-registry glance-api

 RESTART nova-api nova-cert nova-consoleauth nova-scheduler nova-conductor nova-novncproxy

 RESTART neutron-server neutron-plugin-openvswitch-agent neutron-l3-agent neutron-dhcp-agent neutron-metadata-agent nova-compute neutron-plugin-openvswitch-agent

 RESTART cinder-scheduler cinder-api tgt cinder-volume

 RESTART heat-api heat-api-cfn heat-engine

 END
