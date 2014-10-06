import sys
import nltk
if len(sys.argv)<=1:
    print "Usage 'python englishTagger <sentence>"
else:
    sentence=""
    for i in range(1,len(sys.argv)):
	sentence=sentence+sys.argv[i]+" "
postags= nltk.pos_tag(nltk.word_tokenize(sentence))
print postags
