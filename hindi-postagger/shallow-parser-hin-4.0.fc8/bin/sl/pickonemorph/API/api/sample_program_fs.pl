#!/usr/bin/perl

require('./feature_filter.pl');
$sample_shaktiString=<stdin>;
$firstReference=&read_FS($sample_shaktiString);
&printFS_SSF($firstReference);
print "\n------------------------\n";
$sample_shaktiString=<stdin>;
$firstReference=&read_FS($sample_shaktiString);
&printFS_SSF($firstReference);
print "\n------------------------\n";
$string=<stdin>;
$hash=&read_FS($string);
print "\n------------------------\nThe first FS :\n $string \n\n";
&printFS_SSF($hash);
print "\n------------------------\n";
$string1=<stdin>;
$hash2=&read_FS($string1);
$hash3=&unify($hash,$hash2);


print "After Unification of FS1 and FS2: \n\n";
if($hash3!=-1)
{
	&printFS_SSF($hash3);
	print "\n----------------------\n";
}
else
{
	print "\nERROR-----------------\n";
}


@finalArray=&get_values("af4",$hash);
print "The Values of the attribute af4 : \n";

&printFS_SSF(\@finalArray);
=s
for($i=0;$i<@finalArray;$i++)
{
	$string=$finalArray[$i];
	if(not(ref($string) eq "HASH"))
	{
		print "$string";
	}
	else
	{
		&printFS_SSF_2($string);
	}
}
=cut
print"\n------------------------------\n";


$newVal[0]="Pratap1234";
&add_attr_val("af4.cf2.aka",\@newVal,$hash);
undef($newVal[0]);
$newVal[0]="Pratap12343";
&add_attr_val("af4.cf2.aka",\@newVal,$hash);
$newVal[0]="Pratap12345";
&add_attr_val("af4.cf2.aka2",\@newVal,$hash);
print "After adding three new attribute value pairs: \n\n";
&printFS_SSF($hash);
print "\n-----------------------------\n";
$newVal[0]="Pratap12345";
&update_attr_val("af4.cf2.aka",\@newVal,$hash);
#&del_attr_val("af4.cf2.aka",$hash);
print "After updating the attribute af4.cf2.aka s value: \n\n";
&printFS_SSF($hash);
print "\n------------------------------\n";
@array=&get_path_values("nf4",$hash);

for($i=0;$i<@array;$i++)
{
	print "$array[$i][0]\n";
}

print "\n--------------------------------\n";
$string=<stdin>;
chomp($string);
$hash5=&read_FS($string);
&printFS_SSF($hash5);
print "\n";
@finalArray=&get_values("af5",$hash5);
print "The Values of the attribute af5 : \n";
&printFS_SSF(\@finalArray);
print "\n";
$ret=&prune_FS("",0,$hash5);
&del_attr_val("af5",$hash5);

&printFS_SSF($hash5);

print "\n$ret-------------------------------\n";
