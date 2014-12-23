#!/bin/bash
grep -q controller /etc/hosts
if [[ $? == 0 ]]
then
   echo "controller is defined already"
else
   echo "adding controller as localhost to /etc/hosts"
   echo "127.0.0.1	controller" >> /etc/hosts
fi

