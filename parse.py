#!/usr/bin/python2.7
from HTMLParser import HTMLParser

import sys,warnings

def attr_check(attrs,key,val):
    for (k,v) in attrs:
        if (k==key and v==val):
            return True
    return False


class MyHTMLParser(HTMLParser):

    def __init__(self):
        """Initialize and reset this instance."""
        self.reset()
        self.tag_stack = []
        self.mode_stack = ["before doc start"]
        self.unwanted_data = ""
        self.watches ={}
        # self.mode = ["before doc start"]
        self.comment = []
        self.code = []

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
        for (k,v) in attrs:
            mode = self.check(tag,k,v)
            if (mode):
                return((k,v,mode)) # guarantees that we only react to the first match
        return None

    def handle_starttag(self, tag, attrs):
        checked = self.checks(tag,attrs)
        self.tag_stack.append((checked,tag))
        if (not checked):
            print "?Encountered an unregistered start tag :", tag
        else:
            k,v,mode=checked
            print "!Encountered a registered start tag (mode==", mode , "):", tag,k,v,
            if (self.mode() == "before doc start"):
                print "??before start of document"
                assert mode == "html"
            elif (self.mode() == "after end of doc"):
                print "??after end of document"
                assert False
            elif (mode == "body"):
                assert self.mode() == ""
                print "##start of document"
            else:
                if (mode == "ignore"):
                    print "??ignoring data"
                elif (mode == "code"):
                    # assert self.mode() == "body" # no nested code sections allowed
                    if ( self.mode() == "body" ): # no nested code sections allowed
                        print "warning: nested code tags!"
                    print "!!emitting code :"
                    for data in self.code:
                        print "!!",data
                else:
                    print "???unknown mode!"
                    assert False
            self.mode_set(mode)

    def handle_endtag(self, tag):
        checked,start_tag = self.tag_stack.pop()
        if (not checked):
            print "?Encountered an unregistered end tag :", tag
        else:
            k,v,mode=checked
            print "!Encountered a registered end tag (current mode == ", self.mode(),", tag mode ==", mode , "):", tag,k,v,
            if (not self.tag_stack):
                assert mode == "html"
                self.mode_set("after end of doc")
            else: # there is at least one tag below us still on the stack...
                assert mode == self.mode()
                self.mode_pop()
                if (tag == "body"):
                    print "##end of document"
                    # do any final cleanup if needed
                elif (mode == "ignore"):
                    print "??ignoring data"
                elif (mode == "code"):
                    print "!!emitting code :"
                    for data in self.code:
                        print "!!",data
                else:
                    print "???unknown mode!"
                    assert False

    def handle_data(self, data):
        if (self.mode() == "code"):
            print "!Encountered some code  :", data
            self.code.append(data)
        elif (self.mode() == "body"):
            print "!Encountered some body text  :", data
            # self.comment += ' '.join(data.translate(None,"\n\t").split())
            self.comment.append(data)
        elif (self.mode() == "ignore"):
            pass
        elif (self.mode() == "html"):
            pass
        elif (self.mode() == "before doc start"):
            pass
        else:
            print "Mode: ", self.mode(), " ?Encountered some unexpected data  :", data
            assert False

my_file = open(sys.argv[1], 'r')

parser = MyHTMLParser()
parser.register("html","","","html")
parser.register("body","","","body")
parser.register("","class","screen","code")
parser.register("","class", "programlisting brush: bash; " ,"code")
parser.register("code","","","code")
parser.register("script","","","ignore")
parser.register("style","","","ignore")
parser.register("","class","navLinks","ignore")
parser.register("","class","statustext","ignore")
parser.register("","class","breadcrumbs","ignore")
parser.register("","id","toolbar","ignore")
parser.feed(my_file.read())
parser.close()
