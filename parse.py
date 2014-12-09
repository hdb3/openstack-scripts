#!/usr/bin/python2.7
from HTMLParser import HTMLParser

LINE_LENGTH = 120

import sys , argparse

class Logger(object):

    def __init__(self):
        self.stdout = sys.stdout
        self.null = open("/dev/null", 'w')
        self.device = self.stdout

    def write(self, message):
        self.device.write(message)

    def off(self):
        self.device = self.null

    def on(self):
        self.device = self.stdout


def attr_check(attrs,key,val):
    for (k,v) in attrs:
        if (k==key and v==val):
            return True
    return False

def _nsplit(s,n):
    output = []
    words = s.split()
    while (words):
        line = words.pop(0)
        while (words and len(line)+len(words[0]) < n):
            line += " " + words.pop(0)
        output.append(line)
    return output

def nsplit(s):
    return _nsplit(s,LINE_LENGTH)

class MyHTMLParser(HTMLParser):

    def __init__(self):
        """Initialize and reset this instance."""
        self.reset()
        self.tag_stack = []
        self.flag_stack = []
        self.mode_stack = ["**INIT**"]
        self.unwanted_data = ""
        self.watches ={}
        self.flag_watches ={}
        self.flags = set([])
        self.filenames = set([])
        self.running_filename=""
        self.replaceables = set([])
        self.comment = ""
        self.code = ""
        self.output = []
        self.comments = False
        self.linebreak_tags = set(["p","h1","h2"])
        self.substitute = False
        self.substitutions = {}

    def enable_comments(self):
        self.comments = True

    def normalise(self,s):
        return ' '.join(s.translate(None,"\n\t").split())

    def mode(self):
        return self.mode_stack[-1]

    def mode_set(self,mode):
        self.mode_stack.append(mode)

    def mode_pop(self):
        return self.mode_stack.pop()

    def register(self,tag,attr,val,type):
        self.watches[tag,attr,val]=type

    def flag_register(self,tag,attr,val,type):
        self.flag_watches[tag,attr,val]=type

    def flag_check(self,tag,attr,val):
        flags=set([])
        if (tag,attr,val) in self.flag_watches:
            flags.add(self.flag_watches[tag,attr,val])
        if ("",attr,val) in self.flag_watches:
            flags.add(self.flag_watches["",attr,val])
        if (tag,"","") in self.flag_watches:
            flags.add(self.flag_watches[tag,"",""])
        return flags

    def flag_checks(self,tag,attrs):
        flags = self.flag_check(tag,"","") # handle case where the tag has no attributes
        for (k,v) in attrs:
            flags |= self.flag_check(tag,k,v)
        return flags

    def check(self,tag,attr,val):
        if (tag,attr,val) in self.watches:
            return self.watches[tag,attr,val]
        if ("",attr,val) in self.watches:
            return self.watches["",attr,val]
        if (tag,"","") in self.watches:
            return self.watches[tag,"",""]
        return None

    def checks(self,tag,attrs):
        if (attrs):
            for (k,v) in attrs:
                mode = self.check(tag,k,v)
                if (mode):
                    return((k,v,mode)) # guarantees that we only react to the first match
        else:
            mode = self.check(tag,"","") # now handle case where the tag has no attributes
            if (mode):
                return (None,None,self.check(tag,"","")) 

    def flush_code(self):
        def not_sql(s):
            if (not s):
                return True
            return (s[0] != '|' and s[0] != '+')
        if self.code:
            # self.output.append(self.code)
            munged_code=self.code.replace("\\\n","")
            lines = munged_code.splitlines()
            codelines = filter(not_sql,lines)
            self.output += codelines
            # self.output.append(munged_code)
            self.code = ""

    def flush_comment(self):
        if self.comment:
            lines = nsplit(self.comment)
            prefixed_lines = ["! " + line.strip() for line in lines]
            self.output += prefixed_lines
            # self.output += ["!" + line for line in nsplit(self.comment)]
            # self.output.append("!" + self.comment)
            self.comment = ""
        if (self.running_filename):
            self.output.append( "{" + self.running_filename + "}" )
            self.running_filename = ""

    def handle_starttag(self, tag, attrs):
        flags = self.flag_checks(tag,attrs) # which flags are requested?
        new_flags = flags - self.flags      # which NEW flags are being set?
        self.flags |= new_flags             # add the flags to the global set
        self.flag_stack.append(new_flags)   # save the list of flags added so we can remove them as we exit the tag
        mode_change = False
        print "?STARTTAG (",self.mode(),") ",
        checked = self.checks(tag,attrs)
        self.tag_stack.append((checked,tag))
        if (not checked):
            print "Unregistered start tag :", tag
        else:
            k,v,mode=checked
            print "Registered start tag (mode==", mode , "):", tag,k,v,

            modes = self.mode(),mode
            mode_change = ( modes[0] != modes[1] ) # this is a mode change transition
            if (self.mode() == "**INIT**"):
                print "before start of document"
                assert mode == "html"
            elif (self.mode() == "after end of doc"):
                print "after end of document"
                 # assert False
            elif (mode == "html"):
                assert self.mode() == "**INIT**"
                print "start of document"
            else:
                if (mode == "body"):
                    print "comment text starting"
                elif (mode == "ignore"):
                    print "ignoring data"
                elif (mode == "code"):
                    # assert self.mode() == "body" # only if no nested code sections allowed
                    if ( self.mode() == "body" ): # no nested code sections allowed
                        print "warning: nested code tags!"
                else:
                    print "unknown mode!"
                    assert False
            self.mode_set(mode)
        if( mode_change):
            print "?MODE CHANGE (START TAG) :", modes[0], " -> ", modes[1]
            if (modes[1] == "code" or modes[0] == "html" ): # only flush comment text when we are starting on a code section or at the end of a doc
                print "?FLUSH COMMENT"
                self.flush_comment()


    def handle_endtag(self, tag):
        self.flags -= self.flag_stack.pop()
        mode_change = False
        print "?ENDTAG (",self.mode(),") ",
        checked,start_tag = self.tag_stack.pop()
        if (not checked):
            print "Unregistered end tag :", tag
            # if (self.mode() == "body" and self.comment and tag == "p"):
            if (self.mode() == "body" and self.comment and tag in self.linebreak_tags):
                self.flush_comment()
        else:
            k,v,mode=checked
            print "Registered end tag (current mode == ", self.mode(),", tag mode ==", mode , "):", tag,k,v,
            if (not self.tag_stack):
                assert mode == "html"
                self.mode_set("after end of doc")
            else: # there is at least one tag below us still on the stack...
                assert mode == self.mode()
                modes = self.mode_stack[-1],self.mode_stack[-2]
                mode_change = (modes[0] != modes[1]) # is this is a mode change transition?
                self.mode_pop()
                if (tag == "body"):
                    print "##end of document"
                elif (mode == "ignore"):
                    print "ignoring data"
                elif (mode == "code"):
                    print "emitting code :"
                else:
                    print "unknown mode!"
                    assert False
            self.flush_code() # assume that every code-like element needs it's own line(s)
            if ( mode_change ):
                print "?MODE CHANGE (END TAG) :", modes[0], " -> ", modes[1]
                if (modes[1] == "code" or modes[0] == "html" ): # only flush comment text when we are starting on a code section or at the end of a doc
                    print "?FLUSH COMMENT"
                    self.flush_comment()

    def handle_data(self, data):
        mode = self.mode()
        print "?DATA (",mode,") {",self.flags,"}",

        if ("filename" in self.flags):
            self.filenames.add(data)
            self.running_filename=data
        if ( mode == "code" and {"code_tag","replaceable"} <= self.flags):
            self.replaceables.add(data)

        if (mode == "code"):
            print "Data :", data,
            if ( self.annotate_replaceable and "replaceable" in self.flags):
                self.code += '$'
            if (self.substitute and "replaceable" in self.flags and data in self.substitutions):
                self.code += self.substitutions[data]
            else:
                self.code += data
        elif (mode == "body"):
            if (self.comments):
                self.comment += " " + ' '.join(data.translate(None,"\n\t").split())
            print "Data :", data,
        elif (mode == "ignore"):
            pass
        elif (mode == "html"):
            pass
        elif (mode == "**INIT**"):
            pass
        else:
            print "Mode: ", mode, "Unexpected data  :", data,
             # assert False
        print

argparser = argparse.ArgumentParser(description='Parse OpenStack documentation in HTML format, to extract executable script fragments.')
argparser.add_argument('infile', nargs='?', type=argparse.FileType('r'),  default=sys.stdin)
argparser.add_argument('outfile', nargs='?', type=argparse.FileType('w'), default=sys.stdout)
argparser.add_argument('-c', '--comments', action='store_true', help='Write non-code text as comments to the output' )
argparser.add_argument('-r', '--replaceable', action='store_true', help='Annotate replaceable tokens in code with a leading"$"' )
argparser.add_argument('-s', '--substitute', action='store_true', help='read a list of substitutions from replaceables.txt' )
argparser.add_argument('-d', '--debug', action='store_true', help='Dump parsing events to stderr' )
args=argparser.parse_args()
input=args.infile
output=args.outfile

sys.stdout = sys.stderr

parser = MyHTMLParser()

if (args.substitute):
    parser.substitute = True
    repfile = open("replaceables.txt",'r')
    repstring = repfile.read()
    replist = repstring.splitlines()
    for rep in replist:
        if (rep.find('=') != -1):
            pos = rep.index('=')
            key = rep[:pos].strip()
            value = rep[pos+1:].strip()
            parser.substitutions[key] = value

# if (parser.substitutions):
    # print "using the following substitution table:", parser.substitutions

if (args.comments):
    parser.enable_comments()

parser.annotate_replaceable=args.replaceable

if (input.isatty()):
    sys.stderr.write("No input file specified and input is not a pipe!\n")
    sys.exit()

sys.stdout = Logger()
if (args.debug):
    sys.stdout.on()
else:
    sys.stdout.off()

parser.flag_register("code","class","filename","filename")
parser.flag_register("code","","","code_tag")
parser.flag_register("em","class","replaceable","replaceable")

parser.register("html","","","html")
parser.register("body","","","body")
parser.register("","class","screen","code")
parser.register("","class", "programlisting brush: bash; " ,"code")
parser.register("script","","","ignore")
parser.register("style","","","ignore")
parser.register("","class","navLinks","ignore")
parser.register("","class","statustext","ignore")
parser.register("","class","breadcrumbs","ignore")
parser.register("","id","toolbar","ignore")

parser.feed(input.read())
result=parser.output
parser.close()
if (args.infile.name != "<stdin>"):
    output.write('<|' + args.infile.name + '|>\n')
for line in result:
    output.write(line + '\n')

sys.stdout = sys.stderr

print "filenames"
for k in iter(parser.filenames):
    print ":: ",k

print "replaceables"
for k in iter(parser.replaceables):
    if (k in parser.substitutions):
        print ":: ",k, "==>", parser.substitutions[k]
    else:
        print ":: ",k
