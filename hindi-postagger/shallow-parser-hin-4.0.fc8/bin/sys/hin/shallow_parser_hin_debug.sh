# Language Independent Module start

# Tokenizer
sh $SHALLOW_PARSER_HIN/bin/sl/tokenizer/tokenizer.sh $1 > $2/tokenizer.tmp

# Language Independent Module end




# Language Specific (Hindi) Module start

# Morph Analyzer
sh $SHALLOW_PARSER_HIN/bin/sl/morph/hin/morph.sh $2/tokenizer.tmp > $2/morph.tmp
# POS Tagger
sh $SHALLOW_PARSER_HIN/bin/sl/postagger/hin/postagger.sh $2/morph.tmp > $2/postagger.tmp
# Chunker
sh $SHALLOW_PARSER_HIN/bin/sl/chunker/hin/chunker.sh $2/postagger.tmp > $2/chunker.tmp

# Language Specific Module end


# Language Independent Modules start

# Pruning
sh $SHALLOW_PARSER_HIN/bin/sl/pruning/pruning.sh $2/chunker.tmp > $2/pruning.tmp
#Guess Morph (This is language dependent)
sh $SHALLOW_PARSER_HIN/bin/sl/guess-morph/hin/guess-morph.sh $2/pruning.tmp > $2/guess-morph.tmp
# Pickone Morph
sh $SHALLOW_PARSER_HIN/bin/sl/pickonemorph/pickonemorph.sh $2/guess-morph.tmp > $2/pickonemorph.tmp
# Head Computation
sh $SHALLOW_PARSER_HIN/bin/sl/headcomputation/headcomputation.sh $2/pickonemorph.tmp > $2/headcompute.tmp
# Vibhakti Computation
sh $SHALLOW_PARSER_HIN/bin/sl/vibhakticomputation/vibhakticomputation.sh $2/headcompute.tmp > $2/vibcompute.tmp
perl $SHALLOW_PARSER_HIN/bin/sl/vibhakticomputation/printinput.pl $2/vibcompute.tmp 
# Language Independent Module end

