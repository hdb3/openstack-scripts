#!/bin/bash
for s in `cat services`
    do
        echo "stop $s"
        sudo service $s stop
    done 

for project in `cat projects`
    do
        echo "clean log files for $project"
        sudo rm -rf /var/log/$project/*
    done

for s in `cat services`
    do
        echo "start $s"
        sudo service $s start
    done 
