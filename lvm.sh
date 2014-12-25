#!/bin/bash
sudo pvcreate $1
sudo vgcreate cinder-vg $1
