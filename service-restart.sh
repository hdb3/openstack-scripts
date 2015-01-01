#!/bin/bash

source utils.sh
set -e
if [[ $# > 0 ]]
  then
    for arg do
      RESTART $arg
    done
  else
    RESTART $ALL
fi
