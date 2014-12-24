rm -f /tmp/edit.tmp
for delta in `ls os.*.files`
do
    echo "### $delta" >> /tmp/edit.tmp
    cat $delta >> /tmp/edit.tmp
done
./edit.py -v /tmp/edit.tmp
./edit.py -w /tmp/edit.tmp
