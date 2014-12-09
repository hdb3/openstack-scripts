#!/bin/bash
./sql.py total.txt | mysql -vv -f -u root -p
