#! /usr/bin/perl

#	Report Bugs to prashanth@research.iiit.ac.in
#
#	Usage : perl convert-BIOtoSSF.pl < bio.txt > ssf.txt
#
#

my $line = "";
my $startFlag = 1;
my $wno = 1;
my $prevCTag = "";
my $error = "";
my $lno = 0;
my $sno = 1;
my $cno=0;

#scan each line from standard input
while($line = <STDIN>)
{
	$lno ++;
	if($line =~ /^\s*$/)
	{	# start of a sentence
		
		print "\t))\t\t\n";
		print "</Sentence>\n\n";
		$startFlag = 1;
		$wno = 1;
		$prevCTag = "";
		$sno ++;
		next;
	}

	if($startFlag == 1)
	{
		print "<Sentence id=\"$sno\">\n";
	}
	chomp($line);
	my @cols = split(/\s+/,$line);

	if($cols[3] =~ /^B-(\w+)/) 
	{
		my $ctag = $1;
		if($prevCTag ne "O" && $startFlag == 0)
		{
			print "\t))\t\t\n";
			$wno++;
		}
		$cno++;
		print "$cno\t((\t$ctag\t\n";
		$wno=1;
		$prevCTag = $ctag;
	}
	elsif($cols[3] =~ /^O/)
	{
		if($prevCTag ne "O" && $startFlag == 0)
		{
			print "\t))\t\t\n";
			$wno++;
		}
		$prevCTag = "O"; 
	}

	if($cols[3] =~ /I-(\w+)/ )
	{	# check for inconsistencies .. does not form a chunk if there r inconsistencies
		my $ctag = $1;
		if($ctag ne $prevCTag)
		{
			$error =$error . "Inconsistency of Chunk tag in I-$ctag at Line no:$lno : There is no B-$ctag to the prev. word\n";
		}
	}
	$cols[2]=~s/___/ /g;
	print "$cno.$wno\t$cols[0]\t$cols[1]\t$cols[2]\n";
	$wno ++;
	$startFlag = 0;
}

