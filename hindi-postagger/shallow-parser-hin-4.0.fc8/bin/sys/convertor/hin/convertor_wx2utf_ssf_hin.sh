perl $SHALLOW_PARSER_HIN/bin/sys/convertor/hin/printinput.pl $1 > /tmp/convertorinput$$.tmp

perl -C $SHALLOW_PARSER_HIN/bin/sys/convertor/hin/convertor.pl -f=ssf -l=hin -s=wx -t=utf -i=/tmp/convertorinput$$.tmp
#perl $SHALLOW_PARSER_HIN/bin/sys/convertor/hin/convertor.pl --path=$SHALLOW_PARSER_HIN/bin/sys/convertor/hin --stype=ssf --tlang=hin -s wx -t utf < /tmp/convertorinput$$.tmp

rm -fr /tmp/convertorinput$$.tmp
	
