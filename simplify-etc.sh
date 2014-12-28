set -e
for f in `cat /home/nic/openstack-scripts/projects` ; do ff="$ff /etc/$f" ; done
find $ff -type f \( -name \*conf -or -name \*ini \) -exec /home/nic/openstack-scripts/simplify.py -i "{}" \;
rm -rf etc.tmp
mkdir -p etc.tmp
find $ff -type f \( -name \*conf -or -name \*ini \) -exec cp "{}" etc.tmp \;
