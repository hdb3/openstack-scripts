#!/bin/bash
for s in `cat rh-services`
    do
        echo "stop $s"
        sudo systemctl stop $s
    done 

for project in `cat projects`
    do
        echo "clean log files for $project"
        sudo rm -rfv /var/log/$project/*
    done

for s in `cat rh-services`
    do
        echo "start $s"
        sudo systemctl start $s
    done 
