#!/bin/bash
sudo pvcreate /dev/sda
sudo vgcreate cinder-volumes /dev/sda
