#!/bin/bash
for j in `cat upstart-jobs` ; do rm -f /etc/init/$j.override ; done
