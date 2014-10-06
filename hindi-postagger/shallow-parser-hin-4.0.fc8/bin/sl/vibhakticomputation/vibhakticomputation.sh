perl $SHALLOW_PARSER_HIN/bin/sl/vibhakticomputation/printinput.pl $1 > /tmp/vibhcomputeinput$$.tmp
#perl $setu/bin/sys/common/printinput.pl $1 > vibhakticomputationinput
perl $SHALLOW_PARSER_HIN/bin/sl/vibhakticomputation/vibhakticomputation.pl --path=$SHALLOW_PARSER_HIN/bin/sl/vibhakticomputation --input=/tmp/vibhcomputeinput$$.tmp
rm -fr /tmp/vibhcomputeinput$$.tmp
