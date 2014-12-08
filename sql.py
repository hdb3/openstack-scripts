#!/usr/bin/python2.7

import argparse,sys

argparser = argparse.ArgumentParser(description='Execute configuration edit scripts.')
argparser.add_argument('infile', nargs='?', type=argparse.FileType('r'),  default=sys.stdin)
argparser.add_argument('outfile', nargs='?', type=argparse.FileType('w'), default=sys.stdout)
argparser.add_argument('-v', '--verbose', action='store_true' )
args=argparser.parse_args()
input=args.infile
output=args.outfile
verbose=args.verbose

if (input.isatty()):
    sys.stderr.write("No input file specified and input is not a pipe!\n")
    sys.exit()

def execute (data):
    for line in data:
        if (line.startswith("$ mysql -u root -p")):
            show=True
        elif (not line or not line[0].isalpha()):
            show=False
        elif (show):
            print line
        else:
            pass

execute(input.read().splitlines())
