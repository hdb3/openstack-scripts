
# edit.py
# applies changes to configuration files
# input is a list of lines which would be valid content
# the role of the function is to merge the changes with an existing file
# this involves locating sections within the file, or creating them if not exists
# and inserting fields within sections, replacing existing fields with the same name
# the file should be left otherwise intact
# example change file is:
change_file = """{keystone/keystone.conf}
[DEFAULT]
...
admin_token = $ADMIN_TOKEN
[database]
...
connection = mysql://keystone:$KEYSTONE_DBPASS@$controller/keystone
[token]
...
provider = keystone.token.providers.uuid.Provider
driver = keystone.token.persistence.backends.sql.Token
[DEFAULT]
...
verbose = True"""

# and a sample existing file is in the location mentioned in the first line
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
    def __init__(self):
        self.running_filename=""
        pass

    def parse(self,lines):
        self.file=lines
        self.running_section=""
        self.fields={}
        self.sections={}
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
            if (c == '{'):
                filename = line[1:line.index('}')].strip()
                self.running_filename=filename
                self.do_filename()
            # parse a section
            elif (c == '['):
                section = line[1:line.index(']')].strip()
                self.running_section=section
                self.do_section()
            # parse a comment
            elif (c == '#'):
                pass
            # parse a field
            elif (line.find('=') != -1):
                pos = line.index('=')
                name = line[:pos-1].strip()
                value = line[pos+1:].strip()
                self.do_field(name,value)
    
            else:            # parse something else...
                pass
                # print "Something else...: ["  + line + "]"

    def do_filename(self):
        pass

    def do_section(self):
        section=self.running_section
        # assert self.running_section not in self.sections # in a change file this may not be a valid assumption!
        self.sections[section] = (self.ln,set([]))

    def do_field(self,name,value):
        section=self.running_section
        assert (section,name) not in self.fields
        self.fields[(section,name)] = self.ln
        (ln,fields) = self.sections[section]
        fields.add(name)
        self.sections[section] = ln,fields

    def dump(self):
        for section,(ln,fields) in self.sections.items():
            print 'Section "' + section + '", at line ', ln, '" has these fields:'
            for field in fields:
                fln = self.fields[(section,field)]
                print '  Field:"'+field+'", at line ', fln

    def apply_delta(self,deltas):
        for ((section,name),d_ln) in deltas.items():
            if ((section,name) in self.fields):
                line = self.fields[(section,name)]
                print "Found matching entries in original and delta for section ", section, " field ",name
                print "Replacing existing line number ", line, " with change line ", d_ln
            elif(section in self.sections):
                line,fields = self.sections[section]
                print "Found new line for existing section, section ", section , " is defined at line ", line
                print "New field: " , name, " is defined at line", d_ln
            else:
                print "New section ", section, " is required"
                print "the new field was defined at ", d_ln


edits=Editor()
edits.parse(change_file.splitlines())
edits.dump()
if (edits.running_filename):
    print "Parsing filename: ",edits.running_filename
    with open(edits.running_filename,'r') as infile:
        scripts=Editor()
        scripts.parse(infile)
        # scripts.dump()
        scripts.apply_delta(edits.fields)
