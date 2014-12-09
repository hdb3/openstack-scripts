apt-get install ubuntu-cloud-keyring &&
echo "deb http://ubuntu-cloud.archive.canonical.com/ubuntu" "trusty-updates/juno main" > /etc/apt/sources.list.d/cloudarchive-juno.list &&
apt-get update &&  apt-get -y dist-upgrade &&
for f in `cat openstack.packages` ; do apt-get install -y $f ; done
