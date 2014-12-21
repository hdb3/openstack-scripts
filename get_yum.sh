wget -nH -r -l 1 http://docs.openstack.org/juno/install-guide/install/yum/content/
mkdir -p yum-content
mv juno/install-guide/install/yum/content/*html yum-content
rm -rf juno
tar czf content.tgz yum-content
rm -rf yum-content
