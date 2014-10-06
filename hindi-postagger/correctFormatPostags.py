import os
import sys
def correctGivenInput(lines):
    onlyTags=[]
    for line in lines:
        a=line.split()
        if len(a)>2:
            l=[a[1],a[2]]
            onlyTags.append(l)
    return onlyTags

if os.path.isfile(sys.argv[1]):
    a = sys.argv[1]
    inp = open(a,'r')
    theWholeFile = inp.read()
    lines = theWholeFile.splitlines()
    requiredType = correctGivenInput(lines)
    print requiredType

else:
    print "Usage : python correctFormatPostags.py <full-path-to-file>"

