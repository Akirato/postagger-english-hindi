#/usr/bin/perl


use Getopt::Long;
sub pick_one_morph
{

	GetOptions("help!"=>\$help,"path=s"=>\$pick_one_home,"resource=s"=>\$db_file,"input=s"=>\$input,"output:s",\$output);
	print "Unprocessed by Getopt::Long\n" if $ARGV[0];
	foreach (@ARGV) {
		print "$_\n";
		exit(0);
	}
	if($help eq 1)
	{
		print "Pick One Morph - Pick One Morph Version 1.1\n     (23th September 2008)\n\n";
		print "usage : ./run-pick-one-morph.pl --path=\"pick_one_home path\" [--input=\"input_file\"] [--output=\"output_file\"] \n";
		print "\tIf the output file is not mentioned then the output will be printed to STDOUT\n";
		exit(0);
	}

	if($pick_one_home eq "")
	{
		print "Please Specify the Path as defined in --help\n";
		exit(0);

	}

	$src="$pick_one_home/src";
	$api="$pick_one_home/API";
	require "$src/prune_default.pl";
	require "$api/shakti_tree_api.pl";
	require "$api/feature_filter.pl";

	if ($input eq "")
	{
		$input="/dev/stdin";
	}
	&read_story($input);

	$numBody = &get_bodycount();
	for(my($bodyNum)=1;$bodyNum<=$numBody;$bodyNum++)
	{
		$body = &get_body($bodyNum,$body);
		# Count the number of Paragraphs in the story
		my($numPara) = &get_paracount($body);
		# Iterate through paragraphs in the story
		for(my($i)=1;$i<=$numPara;$i++)
		{
			my($para);
			# Read Paragraph
			$para = &get_para($i);
			# Count the number of sentences in this paragraph
			my($numSent) = &get_sentcount($para);
			#print $numSent."\n";
			# Iterate through sentences in the paragraph
			for(my($j)=1;$j<=$numSent;$j++)
			{
				#print " ... Processing sent $j\n";
				# Read the sentence which is in SSF format
				my($sent) = &get_sent($para,$j);
				#       &print_tree($sent);
				&prune_default($sent);
			}
		}
	}
	if($output ne "")
	{
		&printstory_file("$output");
	}
	else
	{
		&printstory();
	}

}
&pick_one_morph();
