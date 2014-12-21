sudo bash -v openstack.apt.sh &&
sudo bash -v edit-conf.sh &&
sudo rabbitmqctl change_password guest admin &&
# nned to check that we have got right entries in /etc/hosts...
./build-db_sync.sh | bash -v &&
./build-openstack.sh | bash -v
