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
    show=False
    start_line = ""
    for line in data:
        if (not line):
           pass
        elif (line.startswith("<|")):
            output.write(line + "\n")
            show=False
        elif (line[0] in "$#+|!"):
            show=False
        # elif (line.startswith("{admin-openrc.sh}") or line.startswith("{demo-openrc.sh}")):
            # show=False
        elif (line[0] == '{' and line[-1] == '}'):
            show=True
            start_line = line
        elif (show):
            if (start_line):
                output.write(start_line + "\n")
                start_line = ""
            output.write(line + "\n")
        else:
            pass

execute(input.read().splitlines())
