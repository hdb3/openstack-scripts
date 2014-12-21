for s in `cat services`
    do
        echo "stop $s"
        service $s stop
    done 

for project in `cat projects`
    do
        echo "remove $project"
        rm -rf /etc/$project
        rm -rf /var/log/$project
        rm -rf /var/lib/$project
    done
