#!/usr/bin/python2.7

import argparse,sys

class Editor:
    def __init__(self):
        pass

    def reset(self):
        self.running_section=""
        self.fields={}
        self.sections={}

    def parse(self,lines):
        self.reset()
        self.ln=0
        for line in lines:
            self.parse_line(line)
            self.ln += 1

    def parse_line(self,line):
        if (not line):
            pass
        else:
            c = line[0]
            # parse a section
            if (c == '['):
                section = line[1:line.index(']')].strip()
                self.running_section=section
                self.do_section()
            # parse a comment
            elif (not line.strip() or line.strip()[0] == '#'):
                pass
            # parse a field
            elif (line.find('=') != -1):
                pos = line.index('=')
                name = line[:pos].strip()
                value = line[pos+1:].strip()
                self.do_field(name, value)

            else:            # parse something else...
                pass
                # print "Something else...: ["  + line + "]"

    def do_section(self):
        section=self.running_section
        self.sections[section] = (self.ln,set([]))
        self.fields[section]=[]

    def do_field(self,name,value):
        section=self.running_section
        if (not section and section not in self.sections): # cope when a field occurs before any sections
            self.do_section()
        self.fields[section].append((self.ln, name, value))

    def dump(self):
        for (section, (s_ln,fields)) in self.sections.items():
            print '[' + section + ']'
            for (ln,key,value) in self.fields[section]:
                print key + ' = ' + value

    def sdump(self):
        sections = sorted(self.fields.keys())

        def promote(self,name):
            if (name in sections):
                index = sections.index(name)
                sections.remove(sections.index(name))
                sections.insert(0,nam)

        promote('DEFAULT',sections)
        promote('',sections)
        
        for (section) in sections:
            if (self.fields[section]): # if the section is empty, don't report it
                output.write( '[' + section + ']\n')
            this_section = self.fields[section]
            these_fields = sorted(this_section,key=lambda tup: tup[1])
            for (ln,key,value) in these_fields:
                output.write( key + ' = ' + value + '\n')

    def execute(self,input):
        self.parse(input.splitlines())
        self.sdump()

argparser = argparse.ArgumentParser(description='Execute configuration edit scripts.')
argparser.add_argument('infile', nargs='?', type=argparse.FileType('r'),  default=sys.stdin)
argparser.add_argument('outfile', nargs='?', type=argparse.FileType('w'), default=sys.stdout)
argparser.add_argument('-v', '--verbose', action='store_true')
argparser.add_argument('-i', '--inplace', action='store_true', help = "write the transformed file over the original" )
argparser.add_argument('-e', '--empty', action='store_true', help = "output sections even when they are empty")

args=argparser.parse_args()
input=args.infile

verbose=args.verbose

if (input.isatty()):
    sys.stderr.write("No input file specified and input is not a pipe!\n")
    sys.exit()


data = input.read()

if ( not args.inplace):
    output=args.outfile
else:
    sys.stderr.write("over-writing input file: " + args.infile.name + "\n")
    name = args.infile.name
    input.close()
    output = open(name,'r+')
    output.truncate(0)

delta=Editor()
delta.execute(data)
