
perl $SHALLOW_PARSER_HIN/bin/sl/chunker/hin/ssf2tnt_pos.pl $1 > /tmp/chunkinput_pos$$.tnt

$SHALLOW_PARSER_HIN/bin/sl/CRF++-0.51/crf_test -m $SHALLOW_PARSER_HIN/data_bin/sl/chunker/hin/300k_model_chunker /tmp/chunkinput_pos$$.tnt > /tmp/chunker_out$$.tnt

perl $SHALLOW_PARSER_HIN/bin/sl/chunker/hin/convert_biotossf.pl < /tmp/chunker_out$$.tnt 

rm -fr /tmp/chunkinput_pos$$.tnt /tmp/chunker_out$$.tnt
