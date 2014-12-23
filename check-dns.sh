#!/bin/bash
grep -q controller /etc/hosts
if [[ $? == 0 ]]
then
   echo "controller is defined already"
else
   echo "adding controller as $MY_IP to /etc/hosts"
   echo "$MY_IP" >> /etc/hosts
fi

