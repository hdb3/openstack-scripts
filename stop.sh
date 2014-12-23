for s in `cat services`
    do
        echo "stop $s"
        sudo service $s stop
        sudo rm -f /var/log/$s
    done 

for project in `cat projects`
    do
        echo "clean log files for $project"
        sudo truncate -s 0 /var/log/$project
    done
