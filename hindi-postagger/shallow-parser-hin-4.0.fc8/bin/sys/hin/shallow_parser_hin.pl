#!/usr/bin/perl

# Reading command line arguments
use Getopt::Long;
use File::Basename;

$shallow_parser_home=$ENV{'SHALLOW_PARSER_HIN'};
$mode="fast";
$out_encoding="utf";
$in_encoding="utf";
GetOptions("help!"=>\$help,
		"mode:s" => \$mode,
		"in_encoding:s"=>\$in_encoding,
		"out_encoding:s"=>\$out_encoding,
		"input:s"=>\$input,
		"output:s"=>\$output,
		"version"=>\$ver,
	   );

=for
print "Mode is  $mode\n" if $mode;
print "Language is  $lang\n" if $lang;
print "Input is  $input\n" if $input;
print "Output is  $output\n" if $output;
=cut

if($help eq 1)
{
        print "shallow-parser-hin version 3.0 \n";
        print "usage : shallow_parser_hin  --mode=[debug|fast] --in_encoding=[wx|utf] --out_encoding=[wx|utf] --input=<input_file> --output=<output_file> \n\n";
	print "  --in_encoding  : Encoding of the Input Text [utf or wx]\n";
        print "  --out_encoding : Encoding of the Output Text [utf or wx]\n";
        print "  --mode         : Debug or Fast mode [debug|fast] *Default fast mode\n";
        print "  --input        : Input file\n";
        print "  --output       : Output file\n";
        print "                  Prepared as a part of SAMPARK (ILMT Consortium Project)\n";
        print "                  Author: Avinesh PVS\n";
        print "                  IIIT Hyderabad {shallowparser\@research.iiit.ac.in} \n\n";
	exit(0);
}
if($ver eq 1)
{
        print "shallow-parser-hin version 3.0 \n";
        exit(0);
}
if($shallow_parser_home eq "")
{
	print "Please export SHALLOW_PARSER_HIN variable \n";
	print " ex:  export SHALLOW_PARSER_HIN=/home/shallow-parser-hin-3.0\n";
	exit(0);
}
if($input ne "")
{

	my $input_file_name=basename($input);
	my $input_dir = $input_file_name ;
	my $parser ="/bin/mkdir -p OUTPUT.tmp/$input_dir";
	system($parser);
	$tmp_dir="OUTPUT.tmp/$input_dir";
}
if($output eq "")
{
	if($ARGV[1])
	{
		$output=$ARGV[1];
	}

}
# Checking for each command line arguments
if($input eq "")
{
	if($ARGV[0])
	{
		$input=$ARGV[0];
	}
	else
	{
		$input="/dev/stdin";
	}


	my $parser ="/bin/mkdir -p OUTPUT.tmp/";
	system($parser);
	$tmp_dir="OUTPUT.tmp/";
}

# in_encoding is wx
if($in_encoding eq "wx" or $in_encoding eq "WX" or $in_encoding eq "Wx")
{

	my $src_input="/bin/cp $input $tmp_dir/input.tmp";
	system($src_input);
	if($mode eq "fast")
	{system("sh $shallow_parser_home/bin/sys/hin/shallow_parser_hin_fast.sh $tmp_dir/input.tmp $tmp_dir > $tmp_dir/output_wx.tmp");}
	if($mode eq "debug")
	{system("sh $shallow_parser_home/bin/sys/hin/shallow_parser_hin_debug.sh $tmp_dir/input.tmp $tmp_dir > $tmp_dir/output_wx.tmp");}
	if($mode ne "fast" and $mode ne "debug")
	{print "Please check the Value of mode\n";exit(0);}
	if($output eq "")
	{
		if($out_encoding eq "utf" or $out_encoding eq "UTF" or $out_encoding eq "Utf")
		{
		      system("sh $shallow_parser_home/bin/sys/convertor/hin/convertor_wx2utf_ssf_hin.sh $tmp_dir/output_wx.tmp ");
		}	
		else
		{
			system("cat $tmp_dir/output_wx.tmp");
		}

		exit(0);
	}
	if($output ne "")
	{
		if($out_encoding eq "utf" or $out_encoding eq "UTF" or $out_encoding eq "Utf")
		{
                        system("sh $shallow_parser_home/bin/sys/convertor/hin/convertor_wx2utf_ssf_hin.sh $tmp_dir/output_wx.tmp ssf > $output");
		}
		else
		{
			system("cat $tmp_dir/output_wx.tmp >$output");
		}
		exit(0);
	}

}
# in_encoding is utf
elsif($in_encoding eq "utf" or $in_encoding eq "UTF" or $in_encoding eq "Utf")
{
	my $src_input="/bin/cp $input $tmp_dir/input.tmp";
	system($src_input);
	$flag=0;
	system("sh $shallow_parser_home/bin/sys/convertor/hin/convertor_utf2wx_text_hin.sh $tmp_dir/input.tmp >$tmp_dir/input_utf_wx.tmp");
	if($mode eq "fast")
	{system("sh $shallow_parser_home/bin/sys/hin/shallow_parser_hin_fast.sh $tmp_dir/input_utf_wx.tmp $tmp_dir > $tmp_dir/output_wx.tmp");}
	if($mode eq "debug")
	{system("sh $shallow_parser_home/bin/sys/hin/shallow_parser_hin_debug.sh $tmp_dir/input_utf_wx.tmp $tmp_dir > $tmp_dir/output_wx.tmp");}
	if($mode ne "fast" and $mode ne "debug")
	{print "Please check the Value of mode [fast|debug]\n";exit(0);}
	if($output eq "")
	{
		if($out_encoding eq "utf" or $out_encoding eq "UTF" or $out_encoding eq "Utf")
		{
			system("sh $shallow_parser_home/bin/sys/convertor/hin/convertor_wx2utf_ssf_hin.sh $tmp_dir/output_wx.tmp ");
			$flag=1;
		}
		if($out_encoding eq "wx" or $out_encoding eq "WX" or $out_encoding eq "wx")
		{
			system("cat $tmp_dir/output_wx.tmp");
			$flag=1;
		}
		if($flag==0)
		{
			print "Please check the Value of out_encoding [wx|utf]\n";exit(0);
		}
		exit(0);
	}
	if($output ne "")
	{
		if($out_encoding eq "utf" or $out_encoding eq "UTF" or $out_encoding eq "Utf")
		{
			system("sh $shallow_parser_home/bin/sys/convertor/hin/convertor_wx2utf_ssf_hin.sh $tmp_dir/output_wx.tmp ssf > $output");
		}
		else
		{
			system("cp $tmp_dir/output_wx.tmp  $output");
		}
		exit(0);
	}

}
else
{
        print "shallow-parser-hin version 3.0 \n";
	print "usage : shallow_parser_hin --mode=[debug|fast] --in_encoding=[wx|utf] --out_encoding=[wx|utf] --input=<input_file> --output=<output_file>\n";
	print "  --in_encoding  : Encoding of the Input Text [utf | wx]\n";
	print "  --out_encoding : Encoding of the Output Text [utf | wx]\n";
	print "  --mode         : Debug or Fast mode [debug|fast] *Default fast mode\n";
	print "  --input        : Input file\n";
	print "  --output       : Output file\n";
	print "                 Prepared as a part of SAMPARK (ILMT Consortium Project)\n";
	print "                 Author: Avinesh PVS\n";
	print "                 IIIT Hyderabad {shallowparser\@research.iiit.ac.in}\n\n";

        exit(0);
}
