sudo bash -v openstack.apt.sh &&
sudo bash -v editconf.sh &&
./build-db_sync.sh | bash -v &&
./build-openstack.sh | bash -v
