sudo yum install yum-plugin-priorities
sudo yum install http://dl.fedoraproject.org/pub/epel/7/x86_64/e/epel-release-7-5.noarch.rpm
sudo yum install http://rdo.fedorapeople.org/openstack-juno/rdo-release-juno.rpm
sudo yum upgrade
sudo yum install `cat yum.list`
