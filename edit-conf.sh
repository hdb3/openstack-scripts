#!/bin/bash -e
sudo rm -f /tmp/edit.tmp /tmp/edit2.tmp
for delta in `ls os.*.files`
do
    echo "### $delta" >> /tmp/edit.tmp
    cat $delta >> /tmp/edit.tmp
done
sed -e "s/\$DB_IP/$DB_IP/g ; s/\$MY_IP/$MY_IP/g" < /tmp/edit.tmp > /tmp/edit2.tmp
./edit.py -v /tmp/edit2.tmp
sudo ./edit.py -w /tmp/edit2.tmp
