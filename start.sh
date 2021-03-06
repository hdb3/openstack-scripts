#!/bin/bash -ev
echo "This installer assumes that the ubuntu cloudstack packages are already installed and up-to-date."
echo "It will look for a customisation script named 'custom.<HOST_NAME>"
$( ./set-env.py )
sudo bash -e ./ovs-clean.sh
./config-openvswitch.sh $EXTERNAL_IF
if [[ ! -e .start_run_flag ]]
  then
    ./edit-conf.sh
    sudo sysctl -p
    sed -e "s/\$MY_IP/$MY_IP/g" < admin-openrc.sh.template > admin-openrc.sh
  else
    echo "start running again, not editing conf files..."
fi
touch .start_run_flag
sed -e "s/\$MY_IP/$MY_IP/g" < demo-openrc.sh.template > demo-openrc.sh
./install.sh | bash -ve
bash -e default-settings.sh
./build-images.sh | bash -ve
#./build-demo.sh | bash -ve
