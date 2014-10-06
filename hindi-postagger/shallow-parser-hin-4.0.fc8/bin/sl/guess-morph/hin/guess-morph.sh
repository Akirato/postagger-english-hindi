perl $SHALLOW_PARSER_HIN/bin/sl/guess-morph/hin/printinput.pl $1 > /tmp/guess_morphinput$$.tmp
python $SHALLOW_PARSER_HIN/bin/sl/guess-morph/hin/guess_morph.py /tmp/guess_morphinput$$.tmp
rm -fr /tmp/guess_morphinput$$.tmp
