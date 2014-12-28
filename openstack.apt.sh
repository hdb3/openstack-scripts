set -e
apt-get install -y ubuntu-cloud-keyring
echo "deb http://ubuntu-cloud.archive.canonical.com/ubuntu" "trusty-updates/juno main" > /etc/apt/sources.list.d/cloudarchive-juno.list
for f in `cat openstack.packages` ; do fs="$fs $f" ; done
apt-get update
apt-get -y dist-upgrade
apt-get -y install --reinstall $fs
