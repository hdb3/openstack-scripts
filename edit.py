
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

def parse(lines):
    for line in lines:
        parse_line(line)

def parse_line(line):
    if (not line):
        pass
    else:
        c = line[0]
        if (c == '{'): # parse a filename
            filename = line[1:line.index('}')].strip()
            print "Filename: [" + filename + "]"
        elif (c == '['): # parse a section
            section = line[1:line.index(']')].strip()
            print "Section: [" + section + "]"
        elif (c == '#'): # parse a comment
            print "Comment: ", line
        elif (line.find('=') != -1):
            pos = line.index('=')
            name = line[:pos-1].strip()
            value = line[pos+1:].strip()
            print "Field: [" + name + "],["+ value + "]"
    
        else:            # parse something else...
            print "Something else...: ["  + line + "]"

parse(change_file.splitlines())
