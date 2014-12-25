#!/usr/bin/python2.7
import platform , os , sys
base_name = "custom."
host_name = platform.node()
if (os.path.exists(base_name + host_name)):
    # sys.stderr.write("config file " + base_name + host_name + " linked to " + base_name + "sh\n")
    sys.stderr.write("Using custom environment from " + base_name + host_name + "\n")
    script=open(base_name + host_name , 'r')
    sys.stdout.write(script.read())
    # os.link(base_name + host_name,base_name + "sh")
    sys.exit(0)
else:
    sys.stderr.write("*** Warning - no custom config file found for this host - looked for " + base_name + host_name + "\n")
    sys.exit(1)
