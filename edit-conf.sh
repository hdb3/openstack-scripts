for delta in `ls os.*.files`
do
    echo "### $delta"
    ./edit.py -w $delta
done
