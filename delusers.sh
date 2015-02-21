for user in keystone glance cinder nova neutron heat ; do
    sudo userdel -f $user
    sudo rm -rf  /var/log/$user
    sudo rm -rf /etc/$user
done
