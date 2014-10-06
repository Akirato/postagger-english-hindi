
#Removies the sentence tag 
while($line=<>)
{
	if($line=~/^</)
	{
		next;
	}
	else
	{
		print $line;
	}
}
