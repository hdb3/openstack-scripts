
import nsplit

s = "!  Only instances can access Block Storage volumes. However, the underlying operating system manages the devices associated with the volumes. By default, the LVM volume scanning tool scans the /dev directory for block storage devices that contain volumes. If tenants use LVM on their volumes, the scanning tool detects these volumes and attempts to cache them which can cause a variety of problems with both the underlying operating system and tenant volumes. You must reconfigure LVM to scan only the devices that contain the cinder-volume volume group. Edit the /etc/lvm/lvm.conf file and complete the following actions"
for line in nsplit.nsplit(s,40):
    print line
print "#################"
for line in nsplit.nsplit(s,80):
    print line
print "#################"
for line in nsplit.nsplit(s,120):
    print line
print "#################"
for line in nsplit.nsplit(s,160):
    print line
