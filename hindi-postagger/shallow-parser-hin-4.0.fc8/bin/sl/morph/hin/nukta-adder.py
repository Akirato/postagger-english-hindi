import os,sys,re
import string

f=open(sys.argv[1],"r")

def findPos(str1):
	count=0
	list1=[]
	for ch in str1:
		if(ch=='Z'):
			list1.append(count)
		count+=1
	return list1
			
def addNukta(str1,list1):
	count=0
	newstr=''
	index=0
#	print str1
#	print list1
	for ch in str1:
#		print count,index
		if(len(list1) > index and count==list1[index] and ch!="Z"):
#			print "here"
			newstr+="Z"
			index+=1
			for i in xrange(index,len(list1),1):
				list1[i]-=1
#				print list1
		elif(ch=="Z"):
			index+=1	
			
		newstr+=ch
		count+=1
	if(len(list1) > index and len(str1)==list1[index]):
		newstr+="Z"
	return newstr
			
			
		
		
for i in f:
#	print i.strip("\n")
	
	arr=i.split("\t")
	if(not len(arr)>=3):
		print i.strip("\n")
		continue
	fss=arr[3].split("|")
	lex=arr[1]
	pat=re.compile("<fs af='(.*?),(.*)'")
	pos=findPos(lex)
#	print pos
	final_fs=''
	if(len(pos)):
		for fs in fss:
			lex_root=re.findall(pat,fs)
			rest_fs=lex_root[0][1]
#			print lex_root
			lex_root=addNukta(lex_root[0][0],pos)
			final_fs+="<fs af='"+lex_root+","+rest_fs+"'>|"
		print arr[0]+"\t"+arr[1]+"\t"+arr[2]+"\t"+final_fs.rstrip("|")
	else:
		print i.strip("\n")
