sub sentence_mark {
my $lang = $_[0];
my $string = $_[1];
my $prefix_file = $_[2];
my $joinflag = $_[3];

#print "joinflag:$joinflag\n";
binmode(STDOUT, ":utf8");
# Print the raw input string
#print "Input String to sentence_mark function : ", $string, "\n";
#open my $ACR_FILE, $prefix_file or 
open my $ACR_FILE, "<utf8", $prefix_file or 
die "Error - could not open file '$prefix_file': $!";

# print join " ", <$ACR_FILE>;
# Crux of Acronym Handler
my %acr_hash = map {
               chomp $_; 
               my $acr = $_;
               $acr => sub { $_ =~ s{\.|'}{__}g;return $_; }->() } <$ACR_FILE>;
#my $acr_h_size = scalar keys %acr_hash;
#print "ACR-Hash-count: $acr_h_size\n";

# Reverse Hash to Substitute value to key
my %rev_acr_hash = reverse %acr_hash;
	# Handle emails in text 
	# $_ =~ s/\b([a-zA-Z0-9._-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,4})\b/__email__/g;
	my $email_c = 1;
	while($string =~ m/\b([a-zA-Z0-9._-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,4})\b/g) {
        my $em = $1;
        my $vl = "__email__".$email_c++;
        $string =~ s/\b$1\b/$vl/g;
        $acr_hash{$em} = $vl;
	}
	# Update reverse hash
	%rev_acr_hash = reverse %acr_hash;
	#print %acr_hash, "\n";
	#print %rev_acr_hash, "\n";

	# Handle ellipsis case  .. w1....w2 .. etc.
	#$string =~ s/([^\p{IsN}])([\.]{3,})([^\p{IsN}])/$1 $2 $3/g;

	# Handle website or web page in text
	#$_ =~ s/\b((https?:\/\/|ftp:\/\/|file:\/\/)*[a-zA-Z0-9.-]+\.[a-zA-Z]{2,4}\/?[a-zA-Z0-9_.\-]*)\b/__weblink__/;
	my $web_c = 1;
	while($string =~ m/\b((https?:\/\/|ftp:\/\/|file:\/\/)*[a-zA-Z0-9.-]+\.[a-zA-Z]{2,4}\/?[a-zA-Z0-9_.\-]*)\b/g) {
	my $wl = $1;
	my $vl = "__weblink__".$web_c++;
	$string =~ s/\b$1\b/$vl/g;
	$acr_hash{$wl} = $vl;
	}
	# Update reverse hash
	%rev_acr_hash = reverse %acr_hash;


	# Handle ellipsis ... and ..
	$string =~ s/([\.]{3,})/ __ELLIP3__ /g; 
	my $ellip3 = $1;
	$string =~ s/([\.]{2,2})/ __ELLIP2__ /g; 
	my $ellip2 = $1;

	# Handle hyphens --- and --
	$string =~ s/([\-]{3,})/ __HYPHEN3__ /g; 
	my $hyphen3 = $1;
	$string =~ s/([\-]{2,2})/ __HYPHEN2__ /g; 
	my $hyphen2 = $1;
	# Insert a space in text after . (dot) to handle acronym properly.
	# (don't put space in decimal number)
	$string =~ s/([^\p{IsN}])[\.]([^\p{IsN}])/$1\. $2/g;
	
	# to handle nA email: rashid101b@gmail.com.
	$string =~ s/(.*)([\.])$/$1 $2/g;

	# Seperate out "," except if within numbers (5,300)
	$string =~ s/([^\p{IsN}])[,]([^\p{IsN}])/$1 , $2/g;

	# Seperate out "/" except if within numbers (1/2)
	$string =~ s/([^\p{IsN}])[\/]([^\p{IsN}])/$1 \/ $2/g;

	# Handle Sign of following
	$string =~ s/([^\p{IsN}])[:][-]$/$1 __SIGNF__/g;

	# Seperate out "-" except if within numbers (1-1-2013) [temporary to handle mwe ideal is w1 -JOIN w2 etc.]
	$string =~ s/([^\p{IsN}])( +)[-]([^\p{IsN}])/$1 __HYPHEN__ $3/g;
	$string =~ s/([^\p{IsN}])[-]( +)([^\p{IsN}])/$1 __HYPHEN__ $3/g;

	# Seperate out "-" except if within numbers (1-1-2013) [To handle mwe e.g. w1 -JOIN w2 etc.]
	#$string =~ s/([^\p{IsN}])([-]{1,1})([^\p{IsN}])/$1 -JOIN $3/g;
	if ($joinflag eq "" || lc($joinflag) eq "yes"){
	$string =~ s/([^\p{IsN}])([-]{1,1})([^\"\'\(\[])([^\p{IsN}])/$1 -JOIN $3$4/g;
	}
	else {
	$string =~ s/([^\p{IsN}])([-]{1,1})([^\"\'\(\[])([^\p{IsN}])/$1 - $3$4/g;
	}
	#$string =~ s/([^\p{IsN}])([^ ])[-]([^ \(\[\"\'-])([^\p{IsN}])/$1$2 -JOIN $3$4/g;
	

	# Insert visarga(\u0903) inside a word if colon(\u003A or :) exist within words 
	$string =~ s/([^\p{IsN}])[:]([^ \)\/])([^\p{IsN}])/$1\x{0903}$2$3/g;

	# Seperate out ":" except if within numbers (Mumbai: gateway of india.)
	$string =~ s/([^\p{IsN}])[:]([^\p{IsN}])/$1 : $2/g;

	# Separate multi comma in number 3,53,222 5,999.33 etc.
	$string =~ s/[,]( )/ ,$1/g;

	# Seperate out ";"
	$string =~ s/[;]( *)/ ;$1 /g;

	# turn `into '
	$string =~ s/\`/ \' /g;
	# turn '' into "
	$string =~ s/\'\'/ \" /g;

	# put space around brackets
	$string =~ s/([\(\)\[\]\{\}])/ $1 /g;

	# put space around question word, end of the sentences ?, . | \u0964,
	# except | (vertical bar) to handle || end of the sentence
	#$_ =~ s/([\?\x{0964}])/ $1 /g;

        # clean up extraneous spaces
        $string =~ s/ +/ /g;
        $string =~ s/^ //g;
        $string =~ s/ $//g;

	# Apply acr_hash to handle acronym occur in text
	my ($key, $value, $line, $rev_line);
	for(split (" ", $string)) {
        if(exists $acr_hash{$_}) {
            s/$_/$acr_hash{$_}/;
        }

        $line = $line."$_ "; 
	}

	$string = $line;
	# Print Acronym Marked String
	#print "Acronym Marked Output String: ", $string, "\n\n";

	# put space around symbols except hyphen (-) for multiword and ! for exclemation
	$string =~ s/([\#\$\%\^\&\*\+\=\<\>\'\"\!])/ $1 /g;
	# pu space for urdu punctuation ‘ (\u2018) ’ (\u2019) ، (\u060C)
	$string =~ s/([\x{2018}\x{2019}\x{060C}])/ $1 /g;

	$string = "<S> ".$string;
	#$string =~ s/([^\p{IsN}])([\.?\x{0964}|]+)([^\p{IsN}])/$1 $2<\/S><S>$3/g;
	# Sentence boundry marking improve by incorporating $3 to handle w1[.|?]" next sentence
	# urdu sentence end boundry added ۔ (\u06D4) ؟ (\u061F)
	$string =~ s/([^\p{IsDigit}])([\.?\x{06D4}\x{061F}\x{0964}|]+)( [\"\'])*([^\p{IsN}])/$1 $2$3<\/S><S>$4/g;

	if ($ellip3 ne ""){
	$string =~ s/__ELLIP3__/$ellip3/g;
	}
	else {
	$string =~ s/__ELLIP3__/.../g;
	}

	if ($ellip2 ne ""){
	$string =~ s/__ELLIP2__/$ellip2/g;
	}
	else {
	$string =~ s/__ELLIP2__/../g;
	}

	if ($hyphen3 ne ""){
	$string =~ s/__HYPHEN3__/$hyphen3/g;
	}
	else{
	$string =~ s/__HYPHEN3__/---/g;
	}
	
	if ($hyphen2 ne ""){
	$string =~ s/__HYPHEN2__/$hyphen2/g;
	}
	else{
	$string =~ s/__HYPHEN2__/--/g;
	}
	#print $string;
	#exit;

	$string =~ s/__HYPHEN__/-/g;

	$string =~ s/__SIGNF__/:-/g;

	$string =~ s/<\/S><S>\s*$/<\/S>/g;
	$string =~ s/(.*)([^(<\/S>)]\s)$/$1$2 <\/S>/g;
	$string =~ s/<\/S><\/S>$/<\/S>/g;

	# Apply reverse hash to store actual key occur in text
	for (split (" ", $string)) {
        
        if(exists $rev_acr_hash{$_}) {
            s/$_/$rev_acr_hash{$_}/;
        }

        $rev_line = $rev_line."$_ "; 
    }

	$string = $rev_line;
	# Print Sentence Marked String
	#print "Sentence Marked String : ", $string, "\n\n";
	return  $string;
}

# Split Token based on blank space
sub token_split {
	my $string = $_[0];
	#print "Input to token_split function: $string\n";
	my $sent_head = ""; my $sent_body = ""; my $sent_tail = ""; my $final_sent="";

	my @sentarr = split ("<\/S>",$string); # sentences split
	foreach my $sent (0..$#sentarr){
	$sentarr[$sent] =~ s/^\s*<S>\s*//g;
	$sentarr[$sent] =~ s/\s*$//g;
	#print "mysent",$sentarr[$sent],"\n";

	if ($sentarr[$sent] ne ""){
	my $sentnewno = $sent+1;
	#print "<Sentence\ id=\"$sentnewno\">\n";
	$sent_head = "<Sentence\ id=\"$sentnewno\">\n";
	my @tknarr = split(" ", $sentarr[$sent]);
	foreach my $tkn (0..$#tknarr){
		my $tknno = $tkn+1;
		if ($tknarr[$tkn] ne "" and $tknarr[$tkn] ne "<S>"){
			#print "$tkn\t$tknarr[$tkn]\tunk\n";
			$sent_body = $sent_body."$tknno\t$tknarr[$tkn]\tunk\n";
		}
	}
	#print "<\/Sentence>\n";
	$sent_tail = "<\/Sentence>\n\n";
	$final_sent = $final_sent.$sent_head.$sent_body.$sent_tail;
	# print "Final SSF : $final_sent";
	$sent_body = "";
	}

	}
	return $final_sent;
}

1;
