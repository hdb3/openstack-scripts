#!/usr/bin/python2.7
import platform , os , sys
base_name = "custom."
host_name = platform.node()
if (os.path.exists(base_name + host_name)):
    sys.stderr.write("config file " + base_name + host_name + " linked to " + base_name + "sh\n")
    os.link(base_name + host_name,base_name + "sh")
else:
    sys.stderr.write("*** Warning - no custom config file found for this host - looked for " + base_name + host_name + "\n")
