cat << EOF
<|address-fix.files|>
{/etc/mongodb.conf}
bind_ip = $1
{/etc/mysql/my.cnf}
[mysqld]
bind-address = 0.0.0.0
{/etc/nova/nova-compute.conf}
[libvirt]
virt_type = kvm
{/etc/nova/nova.conf}
[DEFAULT]
novncproxy_base_url = http://$1:6080/vnc_auto.html
metadata_host = $1
dns_server=8.8.8.8
EOF
