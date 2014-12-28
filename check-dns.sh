#!/bin/bash
grep -q '\(controller\)\|\(dbhost\)' /etc/hosts
if [[ $? == 0 ]]
then
   echo "controller or dbhost is defined already"
   exit 1
else
   echo "adding controller as $1 to /etc/hosts"
   echo "$1	controller" >> /etc/hosts
   echo "adding dbhost as $2 to /etc/hosts"
   echo "$2	dbhost" >> /etc/hosts
fi

