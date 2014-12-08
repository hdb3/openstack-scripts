#!/bin/bash
#grep '^\$ \|^#' $1 | grep -v '^# service\|^# ntpq\|^# apt-get\|^# ping \|^\$ ping\|^\$ mysql\|^\$ source' | sed 's/^$ //' | sed 's/^# /sudo /'
grep '^  [[:alpha:]]\|^\$ \|^#' $1 | grep -v '^# service\|^# ntpq\|^# apt-get\|^# ping \|^\$ ping\|^\$ mysql' | sed 's/^$ //' | sed 's/^# /sudo /'
