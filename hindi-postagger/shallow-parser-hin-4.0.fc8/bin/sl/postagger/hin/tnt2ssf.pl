#! /usr/bin/perl
sub tnt2ssf
{
	my $line = "";
	my $startFlag = 1;
	my $wno = 1;
	my $prevCTag = "";
	my $error = "";
	my $lno = 0;
	my $sno = 1;

	print "<Sentence id=\"$sno\">\n";
	#scan each line from standard input
	while($line = <>)
	{
		if($line =~ /^\s*$/)
		{	
			next;
		}

		chomp($line);

		my @cols = split(/[ ]+/,$line);
		$cols[2]=~s/___/ /g;
		print $wno,"\t",$cols[0],"\t",$cols[1],"\t",$cols[2],"\n";
		$wno ++;
	}
	print "</Sentence>\n";
}
&tnt2ssf;
