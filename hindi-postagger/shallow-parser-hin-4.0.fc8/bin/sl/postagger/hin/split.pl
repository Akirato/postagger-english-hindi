#!/usr/bin/perl


sub split {
	my $line;
	while ($line = <>)
	{
		chomp($line);
		my @array = split (/[ \t]+/, $line);
		print $array[0]," ",$array[14]," ",$array[13],"\n";
	}
}
&split;
