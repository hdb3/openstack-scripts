tmp=/tmp/openstack-script-tmp/old-conf-files
rm -rf $tmp &&
mkdir -p $tmp &&
for p in `cat projects`
  do
  sudo chmod -R a+r /etc/$p
  find /etc/$p -type f -execdir cp -b "{}" $tmp \;
  done
