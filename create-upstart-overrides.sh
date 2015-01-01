#!/bin/bash
for j in `cat upstart-jobs` ; do echo "manual" > /etc/init/$j.override ; done
