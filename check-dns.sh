#!/bin/bash
grep -q controller /etc/hosts
if [[ $? ]]
then
   echo "adding controller as localhost to /etc/hosts"
   echo "127.0.0.2	controller" >> /etc/hosts
else
   echo "controller is defined already"
fi

