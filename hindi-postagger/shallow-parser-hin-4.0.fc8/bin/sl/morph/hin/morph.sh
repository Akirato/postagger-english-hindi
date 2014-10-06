perl $SHALLOW_PARSER_HIN/bin/sl/morph/hin/deletesentencetag.pl $1 > /tmp/slput$$.tmp
# | perl $SHALLOW_PARSER_HIN/bin/sl/morph/hin/remove_ssf.pl > /tmp/slput$$.tmp

$SHALLOW_PARSER_HIN/bin/sl/morph/hin/morph_hin.exe --logfilepath morph.log --pdgmfilepath $SHALLOW_PARSER_HIN/data_bin/sl/morph/hin/ --uwordpath $SHALLOW_PARSER_HIN/data_bin/sl/morph/hin/dict_final --dictfilepath $SHALLOW_PARSER_HIN/data_bin/sl/morph/hin/dict/  -ULDWH --inputfile /tmp/slput$$.tmp --outputfile /tmp/sl$$.out

# uncomment below line if want to print nukta in root word

#python $SHALLOW_PARSER_HIN/bin/sl/morph/hin/nukta-adder.py  morph_output | perl $SHALLOW_PARSER_HIN/bin/sys/common/addsentencetag.pl | perl $SHALLOW_PARSER_HIN/bin/sl/morph/hin/adj-gen-1.0/adj_gen.pl

# uncomment below line and comment above line if do not want nukta in root word

perl $SHALLOW_PARSER_HIN/bin/sl/morph/hin/addsentencetag.pl /tmp/sl$$.out

rm -fr /tmp/sl$$.log /tmp/slput$$.tmp /tmp/sl$$.out
