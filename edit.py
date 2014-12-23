#!/usr/bin/python2.7

import os.path, os, argparse,sys
# edit.py
# applies changes to configuration files
# input is a list of lines which would be valid content
# the role of the function is to merge the changes with an existing file
# this involves locating sections within the file, or creating them if not exists
# and inserting fields within sections, replacing existing fields with the same name
# the file should be left otherwise intact
#
# The first action is to read the file and make a backup copy in the file-system
# then, scan the changes
# comments are line starting '#', they can be ignored
# file names are enclosed in '{','}'
# sections start with '[', the section name is within '[' and ']'
# when section name is encountered, set the current section
# other non-blank lines may be config lines:
# when a config line is encountered, parse it, i.e. take the first field delimited by '='
# if no token found, discard the line (if not empty, warn....)
#
# For each token found, scan the input file for a matching section line
# If the section is found, insert the full line of the change file, then, scan until the section ends for any line with the same token
# Delete any such lines
# If the section was not found, add the section in full from the change script.
#
# Parsing files
# the result of parsing each line is stored in dictionaries:
# A section dictionary stores the names of sections and the line number on which they occur
# A field dictionary stores tuples of section-name and field-name, with the line on which they occur

class Editor:
    def __init__(self,mode):
        self.mode=mode
        self.success = []
        self.fail = []
        self.filenames = set([])
        pass

    def reset(self):
        self.running_section=""
        self.fields={}
        self.sections={}
        self.running_filename=""

    def parse(self,lines):
        self.reset()
        self.file=lines
        self.ln=0
        for line in lines:
            self.parse_line(line)
            self.ln += 1

    def parse_line(self,line):
        if (not line):
            pass
        else:
            c = line[0]
            # parse a filename
            if (line.startswith("<|")):
                filename = line[2:line.index('|>')].strip()
                if (verbose):
                    print "input source file is:",filename
            # parse a filename
            if (c == '{'):
                filename = line[1:line.index('}')].strip()
                self.do_filename(filename)
            # parse a section
            elif (c == '['):
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
                self.do_field(name,value)
    
            else:            # parse something else...
                pass
                # print "Something else...: ["  + line + "]"

    def do_filename(self,filename):
        assert self.mode == "delta"
        # if this assertion fails it is probably because the config file we are updating
        # has got some line that looks more like an edit script
        # possibly this could be ignored, but it shouldn't happen
        self.running_filename=filename
        self.running_section=""
        self.filenames.add(filename)

    def process_script(self,filename):
        assert self.mode == "delta"
        scripts=Editor("script")
        print "Processing filename: ",filename
        try:
            if (not zero and os.path.exists(filename)):
                infile= open(filename,'r')
                instring=infile.read()
                infile.close()
                scripts.parse(instring.splitlines())
                if (dump):
                    scripts.dump()
            else:
                if (not zero and verbose):
                    print "Config file <" + filename + "> does not exist: creating it."
                scripts.parse([])
            edits, additions = scripts.calculate_delta(filename,self.fields)
            if (edits or additions):
                if(write_direct):
                    if (os.path.exists(filename)):
                        n=0
                        while (os.path.exists(filename + "." + str(n))):
                            n += 1
                        os.rename(filename,filename + "." + str(n))
                    elif (not os.path.exists(os.path.dirname(filename)) ):
                        if (verbose):
                            print "Making new directory for: ",filename
                        os.makedirs(os.path.dirname(filename))
                    out_file_path = filename
                else:
                    out_file_path = "tmp/"+filename
                    out_file_dir = os.path.dirname(out_file_path)
                    if (not os.path.exists(out_file_dir)):
                        # create the tmp directories
                        os.makedirs(out_file_dir)
                with open(out_file_path,'w') as outfile:
                    mark=0
                    for section,name,line,d_ln,delete in edits:
                        while (mark<line):
                            outfile.write(scripts.file[mark] + "\n")
                            mark += 1
                        if (mark < len(scripts.file) and not delete):
                            outfile.write(scripts.file[mark] + "\n")
                        mark += 1
                        outfile.write(self.file[d_ln] + "\n")
                    while (mark<len(scripts.file)):
                        outfile.write(scripts.file[mark] + "\n")
                        mark += 1
                    for section in additions.keys():
                        if (section):
                            outfile.write("[" + section + "]\n")
                        for (name,d_ln) in additions[section]:
                            outfile.write(self.file[d_ln] + "\n")
                if (verbose):
                    print "Finished processing filename: ",filename
            self.success.append(filename)
        except IOError as e:
            if (verbose):
                print "**** Failed processing filename: ",filename
                print "**** I/O error({0}): {1}".format(e.errno, e.strerror)
            self.fail.append(filename)


    def do_section(self):
        section=self.running_section
        file=self.running_filename
        # assert self.running_section not in self.sections # in a change file this may not be a valid assumption!
        # print "<do_section> File: ",file,"Section: ",section
        self.sections[file,section] = (self.ln,set([]))

    def do_field(self,name,value):
        section=self.running_section
        file=self.running_filename
        # print "<do_field> File: ",file,"Section: ",section,"Field: ",name
        if (not section and (file,section) not in self.sections): # cope when a field occurs before any sections
            self.do_section()
        # if ( (file,section,name) not in self.fields ):
            # warnings.warn("file,section,name) not in self.fields (" + file + "|" + section + "|" + name + ")")
        self.fields[(file,section,name)] = self.ln
        (ln,fields) = self.sections[file,section]
        fields.add(name)
        self.sections[file,section] = ln,fields

    def dump(self):
        for (file,section),(ln,fields) in self.sections.items():
            print 'File ' + file + ' / Section "' + section + '", at line ', ln, '" has these fields:'
            for field in fields:
                fln = self.fields[(file,section,field)]
                print '  Field:"'+field+'", at line ', fln

    def calculate_delta(self,filename,deltas):
        edits=[]
        additions={}
        if (verbose):
            print "  Calculating deltas for ", filename
        for ((file,section,name),d_ln) in deltas.items():
            if (filename != file):
                continue
            if (("",section,name) in self.fields):
                line = self.fields[("",section,name)]
                if (verbose):
                    print "    Replacing entry for", name, "in section [" + section + "]"
                edits.append((section,name,line,d_ln,True))
            elif(("",section) in self.sections):
                line,fields = self.sections[("",section)]
                if (verbose):
                    print "    Inserting new entry for", name, "in section [" + section + "]"
                edits.append((section,name,line,d_ln,False))
            else:
                if (verbose):
                    print "    Inserting new entry for", name, "in new section [" + section + "]"
                update = (name,d_ln)
                if (section not in additions):
                    additions[section] = [update]
                else:
                     additions[section].append(update)
        edits.sort(key=lambda update: update[2])
        if (verbose):
            print "  Finished Calculating deltas for ", filename
        return (edits,additions)

    def execute(self,input):
        self.parse(input.splitlines())
        if (dump):
            self.dump()
        # sys.exit()
        for filename in self.filenames:
            self.process_script(filename)
        return ["Success: " + line for line in self.success] + ["Fail   : " + line for line in self.fail]
        # self.dump()

argparser = argparse.ArgumentParser(description='Execute configuration edit scripts.')
argparser.add_argument('infile', nargs='?', type=argparse.FileType('r'),  default=sys.stdin)
argparser.add_argument('outfile', nargs='?', type=argparse.FileType('w'), default=sys.stdout)
argparser.add_argument('-v', '--verbose', action='store_true')
argparser.add_argument('-d', '--dump', action='store_true', help='dump the symbol tables')
argparser.add_argument('-z', '--zero', action='store_true', help='Build new config files without reading existing')
argparser.add_argument('-w', '--write', action='store_true', help='force direct updates to files, a backup copy will be made...')
args=argparser.parse_args()
input=args.infile
output=args.outfile
verbose=args.verbose
dump=args.dump
zero=args.zero
write_direct=args.write
if ( zero and write_direct ):
    sys.stderr.write("zero and write options are not compatible\n")
    sys.exit()

if (input.isatty()):
    sys.stderr.write("No input file specified and input is not a pipe!\n")
    sys.exit()

delta=Editor("delta")
result = delta.execute(input.read())
if (result):
    for line in result:
        output.write(line + '\n')
