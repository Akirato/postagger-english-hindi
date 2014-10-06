
perl $SHALLOW_PARSER_HIN/bin/sl/postagger/hin/printinput.pl $1 > /tmp/postaggerinput$$

perl $SHALLOW_PARSER_HIN/bin/sl/postagger/hin/ssf2tnt.pl < /tmp/postaggerinput$$  > /tmp/posinput$$.tnt

perl $SHALLOW_PARSER_HIN/bin/sl/postagger/hin/extra_features.pl < /tmp/posinput$$.tnt > /tmp/posextra_input$$.tmp

$SHALLOW_PARSER_HIN/bin/sl/CRF++-0.51/crf_test -m $SHALLOW_PARSER_HIN/data_bin/sl/postagger/hin/300k_model_postagger /tmp/posextra_input$$.tmp > /tmp/poscrfout$$.tmp

perl $SHALLOW_PARSER_HIN/bin/sl/postagger/hin/split.pl < /tmp/poscrfout$$.tmp > /tmp/postagger_out$$.tnt

perl $SHALLOW_PARSER_HIN/bin/sl/postagger/hin/tnt2ssf.pl < /tmp/postagger_out$$.tnt

rm -fr /tmp/postaggerinput$$ /tmp/posinput$$.tnt /tmp/posextra_input$$.tmp /tmp/poscrfout$$.tmp /tmp/postagger_out$$.tnt
