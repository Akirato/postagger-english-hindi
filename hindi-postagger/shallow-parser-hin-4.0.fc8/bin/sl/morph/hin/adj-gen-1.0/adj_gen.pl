#!/usr/bin/perl

use Getopt::Long;
#use Encode;
use File::Basename;

GetOptions('help!'=>\$help, 'input=s'=>\$input, 'output:s'=>\$output, 'version'=>\$ver);

print "Unprocessed by Getopt::Long\n" if $ARGV[0];
foreach (@ARGV) {
       print "$_\n";
       exit(0);
}

if($help eq 1)
{
	print "adjective generator \n";
        exit(0);
}

if($ver eq 1)
{
        print "adjective generator-1.0 \n";
        exit(0);
}


# for ~/Desktop/ or ~/myinput/ directory issue fix
$home = $ENV{"HOME"};
$input =~ s/^~/$home/;
$output =~ s/^~/$home/;

$path = dirname($0);
#print "$path\n";

# SSF API
require "$path/ssfapi/shakti_tree_api.pl";
require "$path/ssfapi/feature_filter.pl";

# convertor-indic lib
#require "$path/lib/IndicCC.pl";

if ($input eq "")
{
        #print "input:$input\n";
        $input="/dev/stdin";
}

sub adj_gen {
    my ($input, $output) = @_;

	open (INFILE, $input) or die "$!";
        if ($output ne "")
        {
            open (OUTFILE, ">$output") or die "$!";
        }
		while($line=<INFILE>)
        	{
                	chomp ($line);
                	($addr, $tkn, $pos, $fs) = split(/\t/,$line);
        	        if($fs ne "")
                	{
	                        @fss = split(/\|/, $fs);
        	                my $len = @fss;
                	        @string  = "";
                        	$newfs = "";
	                        my $i=0;
        	                foreach $af (@fss)
                	        {
	                        	my $FSreference = &read_FS($af, $line);
        	                	my @lex_val = &get_values("lex", $FSreference);
        	                        my @cat_val = &get_values("cat", $FSreference);
                	                my @gen_val = &get_values("gen", $FSreference);
                	                my @num_val = &get_values("num", $FSreference);
					#print "lex:$lex cat:$cat gen:$gen num:$num\n";

					if ($lex_val[0] =~ /(\.)*I$/ and $cat_val[0] eq "adj" and $gen_val[0] eq "f" and $num_val[0] eq "any")
                                        	{
							$lex = $lex_val[0];
							$lex =~ s/I$/A/;
							#print "my lex $lex";
        	                                	my @lex_arr=();
                	                        	push @lex_arr,$lex;
                        	                	&update_attr_val("lex", \@lex_arr, $FSreference, $af);
                                	        	$string[$i] = &make_string($FSreference, $af);
						}
						else
						{
							$lex = $lex_val[0];
        	                                	my @lex_arr=();
                	                        	push @lex_arr,$lex;
                        	                	&update_attr_val("lex", \@lex_arr, $FSreference, $af);
                                	        	$string[$i] = &make_string($FSreference, $af);
							
						}


	                                $i++;
        	                }
				foreach $string (@string)
				{	
					if(--$len)
					{	
        	                       		$newfs=$newfs.$string."|";
					}
					else
					{
						$newfs=$newfs.$string;
					}
				}
				delete @string[0..$#string];
				delete @lex_root[0..$#lex_root];
				delete @fss[0..$#fss];
				if($line =~ /\(\(/ or $line =~ /\)\)/)
				{
					($addr1,$lex,$pos,$fs) = split(/\t/,$line);
                                        if ($output ne "")
                                        {
					#print OUTFILE $num,"\t",$lex,"\t",$pos,"\t",$newfs,"\n";
					print OUTFILE "$addr1\t$lex\t$pos\t$newfs\n";
                                        }
                                        else
                                        {
					print $addr1,"\t",$lex,"\t",$pos,"\t",$newfs,"\n";
                                        }
				}
				else
				{
                                        if ($output ne "")
                                        {
					print OUTFILE $addr,"\t",$tkn,"\t",$pos,"\t",$newfs,"\n";
                                        }
                                        else
                                        {
					print $addr,"\t",$tkn,"\t",$pos,"\t",$newfs,"\n";
                                        }
				}
			} # end if fs ne "" 
			else {  # try to understand this else block
				
				if($lex ne "((" and $lex ne "))")
				{
                                        if ($output ne "")
                                        {
					print OUTFILE $addr,"\t",$tkn,"\t",$pos,"\t",$fs,"\n";
                                        }
                                        else
                                        {
					print $addr,"\t",$tkn,"\t",$pos,"\t",$fs,"\n";
                                        }
				}
				else {
                                        if ($output ne "")
                                        {
					    print OUTFILE $line."\n";
                                        }
                                        else
                                        {
					    print $line."\n";
                                        }
				}
			}


        	} # end while loop
    close(INFILE);
    close(OUTFILE);

} # end of sub convertor_indic

&adj_gen($input, $output);
