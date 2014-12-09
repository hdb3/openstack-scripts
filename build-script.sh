#!/bin/bash
# assumes that the dir content holds the doc files...
# and there is a list of html files in script.list
# will ignore the files commented out in the list
rm -f total.txt
for f in `grep -v '^#' script.list` ; do echo $f ; ./parse.py content/$f >> total.txt ; done
