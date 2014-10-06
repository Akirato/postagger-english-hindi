import sys,os
if len(sys.argv)>1:
	input = open(sys.argv[1], 'r')
else:
	print 'Arguments missing\nPlease provide input and output files'
	sys.exit(0)
output = open('guess-morph-rule1.txt', 'w')
#input10 = open("y",'r')
'''
for line in input:
   index=input.tell()
   print line
   print index
   line = input.readline()
   input.seek(index)
   print line
   r=line.split('\t')
   feature_d = ''
   feature_o = ''
'''
input.seek(0,2)
size=input.tell()
input.seek(0,0)
flag_VGNN=0

while  input.tell() != size:
   line = input.readline()
   index=input.tell()
#  line2 = input.readline()
#   input.seek(index,0)
#  print line,line2
   r=line.split('\t')
   feature_d = ''
   feature_o = ''

   if len(r) > 2:
   	if r[2]=='NN' or r[2]=='NNP' or r[2]=='XC' or r[2]=='NST' or r[2]=='PRP' or r[2]=='VGNN' or (r[2]=='VM' and flag_VGNN ==1):
	        
		if r[2]=='VGNN':
			flag_VGNN = 1
			output.write(line)
			continue
		elif r[2]!='VM':
			flag_VGNN=0
                
		fs = r[3]
		fs_split = fs.split('|')
		if len(fs_split) > 1:
			output.write("%s" % r[0])
			output.write("\t%s" % r[1])
			output.write("\t%s" % r[2])
			flag_d=0
			flag_o=0
			for i in range(0,len(fs_split)):
			     feature = fs_split[i].split(',')
			     if feature[5] == 'd' and flag_d==0:
			     	feature_d = fs_split[i]
			        flag_d=1
			     
			     elif feature[5] == 'd' and flag_d==1:
			     	feature_d = feature_d + '|' +  fs_split[i]
			     
			     if feature[5] == 'o' and flag_o==0:
			     	feature_o = fs_split[i]
			        flag_o=1

			     elif feature[5] == 'o' and flag_o==1:
			     	feature_o = feature_o + '|' +  fs_split[i]
			flag_p=0
			if feature_o=='' and feature_d=='':
				output.write("\t"+ fs.strip()+"\n")
				flag_p=1
			     	
#			line2 = input.next()			        
			if r[2]!='PRP':
#	line2 = next(input)
				line2 = input.readline()
				r1=line2.split('\t')
				if len(r1)>2:
					if r1[2]=='PSP':
						a = len(feature_o)
						if feature_o != '':
							if feature_o[a-1]=='\n':
								output.write("\t%s" %feature_o)
							else:
					        		output.write("\t%s\n" %feature_o)
						elif flag_p==0:
							output.write(fs)
					elif feature_d!='':
						output.write("\t%s\n" %feature_d.strip())
					elif flag_p==0:
						output.write(fs)
					
				else: 
				 	output.write("\t%s\n" %feature_d.strip())
					
#			print feature_d

			elif feature[0].split("'")[1]== r[1] and r[2]=='PRP':
			        if feature_d!='':
					output.write('\t' + feature_d.strip() + '\n')
				elif flag_p==0:
					output.write('\t'+ fs.strip()+'\n')

			else:
				if feature_o!='':
					output.write('\t'+feature_o.strip() + '\n')

				elif flag_p==0:
	                       	        output.write('\t'+fs.strip()+'\n')
		        

			

				

		else:
			output.write(line)
	else :
		output.write(line)
   else :
        output.write(line)
   input.seek(index,0)

output.close()
input1 = open('guess-morph-rule1.txt', 'r')
output = open('guess-morph-rule2.txt','w')
input1.seek(0,2)
end = input1.tell()
input1.seek(0,0)
while input1.tell()!=end:
   line = input1.readline()
#   print line
   flag_psp=0
   r2 = line.split('\t')
   if len(r2) > 2:
   	if r2[2]=='PSP' and (r2[1]=='ke' or r2[1]=='kI'):
	
		if r2[2]=='PSP':
			flag_psp=1
		fs = r2[3]
		fs_split = fs.split('|')
		if len(fs_split) > 1:
			output.write("%s" % r2[0])
			output.write("\t%s" % r2[1])
			output.write("\t%s" % r2[2])
			feature_list = fs_split
			string = '' 
			feature=fs
			flag1=0
			for k in range(0,7):
#	line2 = next(input1)
				line2 = input1.readline()
		#	print line2
				r3 = line2.split('\t')
				if r3[0]=='</Sentence>':
					break

		        	string=string+line2
 				if len(r3)>2:
					feature = fs
					if r3[2]=='NN' or r3[2]=='NNP':
						fs_nn = r3[3]
						fs_nn_split = fs_nn.split('|')
						temp='x'
						flag_same=0
						for k in range(0,len(fs_nn_split)):
							feature_nn = fs_nn_split[k].split(',')
#		print fs_nn_split[k]
							if feature_nn[3]=='sg' or feature_nn[3]=='pl':
								if feature_nn[3]!=temp:
									if temp=='sg' or temp=='pl':
										flag_same=1
										break
									
								temp=feature_nn[3]
						
								
						for j in range(0,len(fs_nn_split)):
                					feature_nn = fs_nn_split[j].split(',')
				         		flag=0
							for i in range(0,len(feature_list)):
								feature_psp = feature_list[i]
                                                                feature_psp_list = feature_psp.split(',')
								
								
           							if feature_psp_list[5]==feature_nn[5] and feature_psp_list[3]==feature_nn[3] and flag==0 and flag_same==0:
									feature = feature_list[i]
									flag=1
									
								elif feature_psp_list[5]==feature_nn[5] and flag==1 and feature_psp_list[3]==feature_nn[3] and flag_same==0:
									feature = feature + '|'+feature_list[i]
								 
								

						a = len(feature)
						if feature[a-1]=='\n':
							output.write("\t%s" %feature)
						else:
					        	output.write("\t%s\n" %feature)
				                flag1 = 1
						break
				if flag_psp==0:
					break

			if flag1 == 0 :
				output.write("\t%s" %feature)
			output.write(string)
		else:
			output.write(line)
	else:
		output.write(line)
   else:
   	output.write(line)

output.close()
flag_print=0
input2 = open('guess-morph-rule2.txt' , 'r')
if len(sys.argv)>2:
	output2 = open(sys.argv[2],'w')
else:
	flag_print=1
input2.seek(0,2)
end1 = input2.tell()
input2.seek(0,0)
while input2.tell()!=end1:
   flag_psp=0
   line = input2.readline()
   r2 = line.split('\t')
   if len(r2) > 2:
   	if r2[2]=='JJ':
		fs = r2[3]
		fs_split = fs.split('|')
		if len(fs_split) > 1:
			if flag_print==0:
				output2.write("%s" % r2[0])
				output2.write("\t%s" % r2[1])
				output2.write("\t%s" % r2[2])

			feature_list = fs_split
			string = '' 
			feature=fs
			flag1=0
			for k in range(0,10):
#	line2 = next(input2)
				line2 = input2.readline()
				r3 = line2.split('\t')
				if r3[0]=='</Sentence>':
					break

		        	string=string+line2
 				if len(r3)>2:
					feature = fs
					if r3[2]=='NN' or r3[2]=='NNP':
						fs_nn = r3[3]
						fs_nn_split = fs_nn.split('|')
						for j in range(0,len(fs_nn_split)):
                					feature_nn = fs_nn_split[j].split(',')
				         		flag=0
							for i in range(0,len(feature_list)):
								feature_psp = feature_list[i]
                                                                feature_psp_list = feature_psp.split(',')
								
								
           							if feature_psp_list[5]==feature_nn[5] and flag==0:
									feature = feature_list[i]
									flag=1
									
								elif feature_psp_list[5]==feature_nn[5] and flag==1:
									feature = feature + '|'+feature_list[i]
								 
								

						a = len(feature)
						if flag_print==0:
							if feature[a-1]=='\n':
								output2.write("\t%s" %feature)
							else:
								output2.write("\t%s\n" %feature)
						else:
							if feature[a-1]=='\n':
								print ("%s\t%s\t%s\t%s" %(r2[0].strip('\n'), r2[1].strip('\n'), r2[2].strip('\n'), feature.strip('\n')))
							else:
								print ("%s\t%s\t%s\t%s" %(r2[0].strip('\n'), r2[1].strip('\n'), r2[2].strip('\n'), feature.strip('\n')))
							
						flag1 = 1
						break
			if flag_print==0:	
				if flag1 == 0 :
					output2.write("\t%s" %feature)
			else:
				if flag1 == 0 :
					print("%s\t%s\t%s\t%s" %(r2[0].strip('\n'), r2[1].strip('\n'), r2[2].strip('\n'), feature.strip('\n')))
				
			if flag_print==0:
				output2.write(string)
			else:	
				print string.strip('\n')
		else:
			if flag_print==0:
				output2.write(line)
			else:
				print line.strip('\n')

	else:
		if flag_print==0:
			output2.write(line)
		else:
			print line.strip('\n')
   else:       
   	        if flag_print==0:
   			output2.write(line)
		else:
			print line.strip('\n')
os.system('rm -f guess-morph-rule1.txt')			
os.system('rm -f guess-morph-rule2.txt')			

