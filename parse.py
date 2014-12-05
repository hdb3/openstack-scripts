#!/usr/bin/python2.7
from HTMLParser import HTMLParser

import sys

def attr_check(attrs,key,val):
    for (k,v) in attrs:
        if (k==key and v==val):
            return True
    return False


class MyHTMLParser(HTMLParser):

    def __init__(self):
        """Initialize and reset this instance."""
        self.reset()
        self.stack = []
        self.unwanted_data = ""
        self.watches ={}

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
    def handle_starttag(self, tag, attrs):
        for (k,v) in attrs:
            if (self.check(tag,k,v)):
                print "!Encountered a wanted tag:", tag,k,v
                if (not self.stack and self.unwanted_data): # we are entering at top level so there may be some 'unwanted' data backed up....
                    print "??Here is some unwanted data...: ", self.unwanted_data
                    self.unwanted_data=""
                self.stack.append((tag,k,v,[]))
                return # prevent pushing multiple items since we won't know how to remove them
        print "?Encountered an unwanted start tag:", tag # only gets here if no wanted tags/attributes are seen
    def handle_endtag(self, tag):
        if (self.stack and self.stack[-1][0] == tag):
            t,k,v,data = self.stack.pop()
            disposition = self.check(tag,k,v)
            print "!Encountered a stacked end tag (disposition==", disposition , "):", tag,k,v, "with ", len(data), " data items",
            if (disposition == "ignore"):
                print "??ignoring data"
            elif (disposition == "code"):
                print "!!emitting code :"
                for line in data:
                    print line
            else:
                print "???unknown disposition!"
        else:
            print "?Encountered an unwanted end tag :", tag
    def handle_data(self, data):
        if (self.stack):
            print "!Encountered some wanted data  :", data
            self.stack[-1][3].append(data)
        else:
            print "?Encountered some unwanted data  :", data
            self.unwanted_data += ' '.join(data.translate(None,"\n\t").split())

my_file = open(sys.argv[1], 'r')

parser = MyHTMLParser()
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
