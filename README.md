openstack-scripts
=================

A collection of scripts which can be used to build basic but complete OpenStack instances suitable for general use.
The scripts are loosely based on the official OpenStack installation documentation.

The target architecture is an all-in-one controller and additional compute nodes as required.
The network architecture is Neutron based, deploying the neutron server and control agent on the main controller node.

The preferred target distribution is Centos - earlier versdions were tested also on Ubuntu, however Ubuntu support for current version would require some (small) amount of work.
It would be preferable to migrate to a framewaork like Puppet if multiple distribution support were required.
