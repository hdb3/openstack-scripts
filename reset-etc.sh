#!/bin/bash
if [ "$EUID" -ne 0 ]
  then echo "Please run as root"
  exit 1
fi

if [ ! -d /etc.baseline/ ]
  then
  echo "/etc.baseline does not exist..."
  exit 1
fi

if [ -d /etc.backup/ ]
  then
  echo "can't backup /etc to /etc.backup, exiting..."
  exit 1
fi

cp -r /etc.baseline /etc.tmp &&
mv /etc /etc.backup &&
mv /etc.tmp /etc &&
echo "/etc was saved as /etc.backup"
