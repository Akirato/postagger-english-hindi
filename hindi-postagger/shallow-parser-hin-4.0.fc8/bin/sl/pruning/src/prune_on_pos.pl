#!/usr/bin/perl


sub fill_hash
{
	my $file=@_[0];
	open(Fp,$file);
	my %hash=();
	while($line=<Fp>)
	{
		chomp($line);
		my @arr=split(/[\t\s]+/,$line);
		$key=$arr[0];
		shift(@arr);
		$array_ref=\@arr;
		$hash{$key}=$array_ref;
	}
	return \%hash
}


# traverse all the node of SSF tree and delete the FS which is incompitable with POS

sub prune_on_pos
{
	$dat_file=@_[0];
	$sent=@_[1];
#	&print_tree();
	if(-e $dat_file )
	{}
	else
	{
		print "Resource File doesn't Exist\n";
		exit(0);
	}
	%mapping={};
	$mapping_ref=&fill_hash($dat_file);
	%mapping=%$mapping_ref;

	my($parent);
	my($fs,@attr,@index);

	my @val=["\"NM\""];
	@index = &get_leaves($sent);
	for($i=0 ; $i<=$#index ; $i++)
	{
		
		($f0,$f1,$f2,$f3,$f4) = &get_fields($index[$i],$sent);
		$ref_categories = $mapping{$f3};
		@categories=@$ref_categories;
		#print "f3= $f3 cat = $cat\n";
	#	print $sent
	#	print "F0==$f0,$f1,$f2,$f3,$f4\n";
         #       print "F4 === $f4\n";
		my $flag=0;
		my $match=0;
         #       print "F2==$f2\n";
	#	print "@sent\n";
		if ($f2 eq'<' or $f2 eq'>')
		{
			  $f4="<fs af='&ang,punc,,,,,,>";
		}

		$fs_ptr = &read_FS($f4,$sent);
	#	print $fs_ptr
		$num_of_fs = &get_num_fs($fs_ptr,$sent);
		$string=&make_string($fs_ptr,$sent);
	#	print "HERE==$num_of_fs";
	#	print "gsk";
#my ($pflag, $sh_pflag, $Dflag, $nflag) = 0;
		$temp = $f4;
#		print $temp;
	#	print "String ==$string\n";
		#print "Complete fs $string\n";
		if($f2 eq '/')
                {
		#	print "HELLO";
                        @value = split(/=/, $string);
                        @val=split(/ /,$value[1]);
        #               print "$value[0]one\ttwo$val[0]end";
#               @attr = &get_values("cat",$fs_ptr,$sent);
#               print "Hello///$attr[0]mkd\n";
		#	print "val==@val";
                        if (($val[0])eq "punc")
                        {
                                $string="<fs af='/,punc,,,,,,>";
                                &modify_field($index[$i],4,$string,$sent);
                        }
#                        else
#                        {
                       	#	print "$f2\tgsk\n";
 #                               $string= join"","<fs af='/,",$val[0],",,,,,,' poslcat='NM'>";
  #                              &modify_field($index[$i],4,$string,$sent);

   #                     }
                }
                else{

		$flag=1;
		if($num_of_fs==1)
		{
			@attr = &get_values("cat",$fs_ptr,$sent);
			$string=&make_string($fs_ptr,$sent);
			foreach $cat (@categories)
			{
				if(($attr[0]) eq ($cat))
				{
					$flag=0;
					last;
				}
			}
			if($flag==1)
			{
				&add_attr_val("poslcat",@val,$fs_ptr,$sent);
				$string=&make_string($fs_ptr,$sent);
				&modify_field($index[$i],4,$string,$sent);
			}
		}
		if($num_of_fs>1)
		{
			#print stderr "FS more than one for $f2\n";
			###this section added to handle PRP,QF,QFN
			$deleted_fs = 0;
			$match=0;
#			print "Number of fs $num_of_fs\n";
			for($j=$num_of_fs-1; $j>=0; $j--)
			{
				$flag=0;
				$fs = &get_fs_reference($fs_ptr,$j,$sent);
				$string=&make_string_2($fs,$sent);
#				print "string $string\n";
				@attr = &get_values_2("cat",$fs,$sent);
				#if(@attr > 0 and lc($attr[0]) ne lc($cat))
				foreach $cat (@categories)
				{
#					print "check -$attr[0] -- $cat\n";
					if(($attr[0]) eq ($cat))
					{	$flag=1;
						$match=1;
						last;
					}
				}
				if($flag==0 and $match!=1)
				{
					&add_attr_val_2("poslcat",@val,$fs,$sent);
					$string=&make_string($fs_ptr,$sent);
					&modify_field($index[$i],4,$string,$sent);
				}
				if(($deleted_fs) == $num_of_fs)
				{
                                        last;
                                }
			}
			if($match==1)
			{
				$deleted_fs = 0;
#				print "Number of fs $num_of_fs\n";
				for($j=$num_of_fs-1; $j>=0; $j--)
				{
					$flag=0;
					$fs = &get_fs_reference($fs_ptr,$j,$sent);
					$string=&make_string_2($fs,$sent);
#					print "string $string\n";
					@attr = &get_values_2("cat",$fs,$sent);
					#if(@attr > 0 and lc($attr[0]) ne lc($cat))
					foreach $cat (@categories)
					{
						 if(@attr > 0 and ($attr[0]) eq ($cat))
						 {
							$flag=1;
							last;
						 }
					}
					if($flag==0)
					{
#						print "DELETED\n";
						$ret=&prune_FS("",$j,$fs_ptr,$sent);
#						print "Return Value $ret\n";
						$deleted_fs++;
					}
#					print "DELTED FS VAL $deleted_fs\n";
					if(($deleted_fs) == $num_of_fs)
					{
						#print stderr "END NOW....$num_of_fs\n";
						last;
					}
				}
			}
			my @catgry;
			my @val_temp = &get_values("cat", $fs_ptr,$sent);
			if($val_temp[0] eq "")#check if already exist..
			{
				$catgry[0] = $cat;
#print stderr "----> $cat\n";
				&update_attr_val("cat",\@catgry,$fs_ptr);
			}

			$string=&make_string($fs_ptr,$sent);
			&modify_field($index[$i],4,$string,$sent);
		}
		else
		{
			##add the category into the feature structure to make sure that for 
			##cases in which morph does not give any category...
			##we make sure that each lexical item has a category in the feature structure.
			my @catgry;
			my @val_temp = &get_values("cat", $fs_ptr,$sent);
			if($val_temp[0] eq "")#check if already exist..change only when 'cat' is empty
			{
				$catgry[0] = $cat;
				&update_attr_val("cat",\@catgry,$fs_ptr,$sent);
			}

			$string=&make_string($fs_ptr,$sent);
			&modify_field($index[$i],4,$string,$sent);

		}
		}
	}
	dbmclose(%mapping);
#	&print_tree_file("prune_on_pos.tmp");
}
1;
