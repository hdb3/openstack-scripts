#!/bin/bash
sudo pvcreate $1
sudo vgcreate ubuntu-vg $1
