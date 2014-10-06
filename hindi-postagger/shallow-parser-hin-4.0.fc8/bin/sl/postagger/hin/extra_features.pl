#!/usr/local/bin/perl

# This program takes argument as file name which contains data in BIO format with the morph input added and will add other features like last 4 letters of the word and so on..(refer to README file for more features) in BIO format.


# psedo code:
#Just read each line and if the line has all space charcters then print \n and continue else print all the features.

while ($line = <>)
{
	chomp($line);
	if($line =~ /^\s*$/)  # if the line has all space charcters 
	{
		print "\n";
		next;
	}
	my ($att1 , $att2 , $att3 ,$att4) = split (/\s+/, $line);
	print $att1," ";
	@array=split(//,$att1);
	$len=@array;
	if($len  < 3) # if the length of the word is less than 3 print LESS 
	{
		print "LESS ";
	}
	else
	{
		print "MORE ";
	}
	if($len >= 4) # if the length of the word is less than 4 print LL which mean its not defined else print the last four charcters of the word
	{
		print $array[-4];
		print $array[-3];
		print $array[-2];
		print $array[-1];
	}
	else
	{
		print "LL"; # here LL means not defined
	}
	print " ";
	if($len >= 3 )
	{
		print $array[-3];
		print $array[-2];
		print $array[-1];
	}
	else
	{
		print "LL";
	}
	print " ";
	if($len >= 2)
	{
		print $array[-2];
		print $array[-1];
	}
	else
	{
		print "LL";
	}
	print " ";
	print $array[-1];
	print " ";
	if($len >= 7)
	{
		print $array[0];
		print $array[1];
		print $array[2];
		print $array[3];
		print $array[4];
		print $array[5];
		print $array[6];
	}
	else
	{
		print "LL";
	}
	print " ";
	if($len >= 6)
	{
		print $array[0];
		print $array[1];
		print $array[2];
		print $array[3];
		print $array[4];
		print $array[5];
	}
	else
	{
		print "LL";
	}
	print " ";
	if($len >= 5)
	{
		print $array[0];
		print $array[1];
		print $array[2];
		print $array[3];
		print $array[4];
	}
	else
	{
		print "LL";
	}
	print " ";
	if($len >= 4)
	{
		print $array[0];
		print $array[1];
		print $array[2];
		print $array[3];
	}
	else
	{
		print "LL";
	}
	print " ";
	if($len >= 3)
	{
		print $array[0];
		print $array[1];
		print $array[2];
	}
	else
	{
		print "LL";
	}
	print " ";
	if($len >= 2)
	{
		print $array[0];
		print $array[1];
	}
	else
	{
		print "LL";
	}
	print " ";
	print $array[0]; # so overall printing the first 1-7 charcters and last 1-4 charcters
	print " ";
	print $att2," ",$att3,"\n";
}
