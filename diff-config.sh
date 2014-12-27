tmp=/tmp/openstack-script-tmp/old-conf-files
for p in `cat projects`
  do
  find /etc/$p -type f -execdir diff "{}" $tmp >> diffs \;
  done
