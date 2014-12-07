#!/usr/bin/python2.7

import argparse,sys

argparser = argparse.ArgumentParser(description='Execute configuration edit scripts.')
argparser.add_argument('infile', nargs='?', type=argparse.FileType('r'),  default=sys.stdin)
argparser.add_argument('outfile', nargs='?', type=argparse.FileType('w'), default=sys.stdout)
argparser.add_argument('-s', '--substitute', action='store_true', help='random option' )
args=argparser.parse_args()
input=args.infile
output=args.outfile

if (args.substitute):
    pass

if (input.isatty()):
    sys.stderr.write("No input file specified and input is not a pipe!\n")
    sys.exit()

def execute (data):
    for line in data:
        print line
    return data[::-1]
    # return data.reverse()

result = execute(input.read().splitlines())
for line in result:
    output.write(line + '\n')

