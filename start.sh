#!/bin/bash -v
tar zxf content.tgz &&
./build-script.sh &&
./files.py total.txt total.files &&
./sql.sh
