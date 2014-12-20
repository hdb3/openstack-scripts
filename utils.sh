
AND='&&'

function END {
echo "echo 'Finished...'"
}

function RM {
 echo "sudo rm -f $1 $AND"
}

function SU {
 echo "sudo su -s /bin/sh -c '$2' $1 $AND"
}

function RESTART {
for arg
do
    echo "sudo service $arg restart $AND"
done
}

function MYSQL {
    echo "mysql -u $DBUSER --password=$DBPASS -vv -f -e \"$1\" $AND"
}

function DB {
MYSQL "DROP DATABASE IF EXISTS $1;"
MYSQL "CREATE DATABASE $1;"
MYSQL "GRANT ALL PRIVILEGES ON $1.* TO '$2'@'localhost'   IDENTIFIED BY '$3';"
MYSQL "GRANT ALL PRIVILEGES ON $1.* TO '$2'@'%'   IDENTIFIED BY '$3';"
}
