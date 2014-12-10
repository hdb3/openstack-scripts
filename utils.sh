#!/bin/bash

function RM {
 echo "sudo rm -f $1"
}

function SU {
 echo "sudo su -s /bin/sh -c '$2' $1"
}

function RESTART {
for arg
do
    echo "sudo service $arg restart"
done
}

function MYSQL {
    echo "mysql -u $DBUSER --password=$DBPASS -vv -f -e \"$1\""
}

function DB {
MYSQL "CREATE DATABASE $1;"
MYSQL "GRANT ALL PRIVILEGES ON $1.* TO '$2'@'localhost'   IDENTIFIED BY '$3';"
MYSQL "GRANT ALL PRIVILEGES ON $1.* TO '$2'@'%'   IDENTIFIED BY '$3';"
}
