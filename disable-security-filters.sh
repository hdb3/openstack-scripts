for rule in `iptables -S | grep mac-source | awk -e ' { print $2 } '` ; do iptables -I $rule 2 -j RETURN ; iptables -D $rule 3 ; done
