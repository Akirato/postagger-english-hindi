#/usr/bin/perl


use Getopt::Long;
sub prune
{

	GetOptions("help!"=>\$help,"path=s"=>\$prune_home,"resource=s"=>\$db_file,"input=s"=>\$input,"output:s",\$output);
	print "Unprocessed by Getopt::Long\n" if $ARGV[0];
	foreach (@ARGV) {
		print "$_\n";
		exit(0);
	}
	if($help eq 1)
	{
		print "PRUNE - Pruning Version 1.9\n     (14th July 2007 last modified on 15th June 2010)\n\n";
		print "usage : ./pruning.pl --path=\"prune_home path\" --resource=\"mapping file\" [--input=\"input_file\"] [--output=\"output_file\"] \n";
		print "\t --path    : Path of the Pruning Directory\n";
		print "\t --resource: Mapping file (data_bin/mapping.dat)\n";
		print "\t --input   : Input file\n";
		print "\t --output  : Output file\n";
		exit(0);
	}

	if($prune_home eq "")
	{
		print "Please Specify the Path as defined in --help\n";
		exit(0);

	}
	if($db_file eq "")
	{
		print "Please Specify the Path of the dat file\n";
		exit(0);

	}

	$src="$prune_home/src";
	$api="$prune_home/API";
	require "$src/prune_on_pos.pl";
	require "$src/prune_on_case.pl";
	require "$api/shakti_tree_api.pl";
	require "$api/feature_filter.pl";

	if(!-e $db_file)
	{
		print "The file doesn't exist\n";
		print "Please Specify the Path of the dat file properly\n";
		exit(0);
	}
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
				&prune_on_pos($db_file,$sent);
				&prune_on_case($sent);
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
&prune();
