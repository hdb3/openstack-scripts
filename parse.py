#!/usr/bin/python2.7
from HTMLParser import HTMLParser

import sys

LINE_LENGTH = 120

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
        self.mode_stack = ["**INIT**"]
        self.unwanted_data = ""
        self.watches ={}
        # self.mode = ["**INIT**"]
        self.comment = ""
        self.code = ""
        self.output = []

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
        if self.code:
            self.output.append(self.code)
            self.code = ""

    def flush_comment(self):
        if self.comment:
            lines = nsplit(self.comment)
            prefixed_lines = ["!" + line for line in lines]
            self.output += prefixed_lines
            # self.output += ["!" + line for line in nsplit(self.comment)]
            # self.output.append("!" + self.comment)
            self.comment = ""

    def handle_starttag(self, tag, attrs):
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
        mode_change = False
        print "?ENDTAG (",self.mode(),") ",
        checked,start_tag = self.tag_stack.pop()
        if (not checked):
            print "Unregistered end tag :", tag
            if (self.mode() == "body" and self.comment and tag == "p"):
                self.comment += "\n! "
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
        print "?DATA (",mode,") ",
        if (mode == "code"):
            print "Data :", data,
            self.code += data
        elif (mode == "body"):
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

my_file = open(sys.argv[1], 'r')

parser = MyHTMLParser()
parser.register("html","","","html")
parser.register("body","","","body")
parser.register("","class","screen","code")
parser.register("","class", "programlisting brush: bash; " ,"code")
# parser.register("code","","","code")
parser.register("script","","","ignore")
parser.register("style","","","ignore")
parser.register("","class","navLinks","ignore")
parser.register("","class","statustext","ignore")
parser.register("","class","breadcrumbs","ignore")
parser.register("","id","toolbar","ignore")
parser.feed(my_file.read())
for line in parser.output:
    print line
parser.close()
