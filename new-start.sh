# sudo bash -v openstack.apt.sh &&
sudo bash -v edit-conf.sh &&
sudo rabbitmqctl change_password guest admin &&
sudo ./check-dns.sh
./build-db_sync.sh | bash -v &&
./build-openstack.sh | bash -v
