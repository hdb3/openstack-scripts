#!/usr/bin/python2.7
from HTMLParser import HTMLParser

import sys

# create a subclass and override the handler methods
class MyHTMLParser(HTMLParser):
    def handle_starttag(self, tag, attrs):
        print "Encountered a start tag:", tag
    def handle_endtag(self, tag):
        print "Encountered an end tag :", tag
    def handle_data(self, data):
        print "Encountered some data  :", data

#with open(sys.argv[1], 'r') as my_file:
#    print(my_file.read())

my_file = open(sys.argv[1], 'r')
# instantiate the parser and fed it some HTML
parser = MyHTMLParser()
parser.feed(my_file.read())
#parser.feed('<html><head><title>Test</title></head>'
#            '<body><h1>Parse me!</h1></body></html>')
