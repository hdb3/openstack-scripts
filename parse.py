#!/usr/bin/python2.7
from HTMLParser import HTMLParser

import sys

class MyHTMLParser(HTMLParser):
    def handle_starttag(self, tag, attrs):
        print "Encountered a start tag:", tag
    def handle_endtag(self, tag):
        print "Encountered an end tag :", tag
    def handle_data(self, data):
        print "Encountered some data  :", data

my_file = open(sys.argv[1], 'r')

parser = MyHTMLParser()
parser.feed(my_file.read())
