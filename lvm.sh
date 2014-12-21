#!/bin/bash
sudo pvcreate /dev/sda
sudo vgcreate ubuntu-vg /dev/sda
