for user in keystone glance cinder nova neutron heat ; do
    echo -n "adding user $user"
    sudo adduser -M $user
    sudo mkdir  -p /var/log/$user
    sudo chown -R $user:$user /var/log/$user
    sudo mkdir -p /etc/$user
    sudo chmod a+rx /etc/$user
    echo " ... done"
done
