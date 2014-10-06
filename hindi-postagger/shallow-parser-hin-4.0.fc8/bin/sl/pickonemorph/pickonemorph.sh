
perl $SHALLOW_PARSER_HIN/bin/sl/pickonemorph/printinput.pl $1 > /tmp/pickonemorphinput$$.tmp

perl $SHALLOW_PARSER_HIN/bin/sl/pickonemorph/pickonemorph.pl --path=$SHALLOW_PARSER_HIN/bin/sl/pickonemorph --input=/tmp/pickonemorphinput$$.tmp

rm -fr /tmp/pickonemorphinput$$.tmp

