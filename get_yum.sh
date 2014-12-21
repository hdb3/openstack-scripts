wget -nH -r -l 1 http://docs.openstack.org/juno/install-guide/install/yum/content/
mkdir -p content
mv juno/install-guide/install/yum/content/*html content
rm -rf juno
tar czf content.tgz content
rm -rf content
