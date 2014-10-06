#!/usr/bin/perl

use GDBM_File;

#the module prunes multiple feature structure (NN, NNP, PRP at present), it also removes the parsarg node in the NP and adds it to its noun fs.

sub prune_on_case
{
	$sent=@_[0];
	#&read();
	my $delete;	#keeps count of all the deleted node, helps in locating node obtained before deletion.

	#get all the noun nodes in the tree, the noun will be case marked '1' if a vibhakti is present, else case is '0'

	my @all_leaves = &get_leaves($sent);	
	#get all the proper noun, case is dependent on parsarg, number is 's'
	#my @NN_nodes = &get_nodes(3, "NN");	#get all the nouns, case is always '0' if no parsarg, else '1'
	
	foreach $node (@all_leaves)
	{
		$pos = &get_field($node, 3,$sent);
		$lex = &get_field($node, 2,$sent);
		$node = $node - $delete;        #always update the node position (cases when some nodes are deleted)
		$pos = &get_field($node, 3,$sent);
		$lex = &get_field($node, 2,$sent);

		if($pos eq "PREP")
		{
			my $feature = &get_field($node - 1, 4,$sent);
			my $prev_tag = &get_field($node - 1, 3,$sent);
			my $prev_lex = &get_field($node - 1, 2,$sent);
			#print stderr "entered the prep block.... prev_fs=$feature\tprev_tag=$prev_tag\n";

			if($prev_tag ne 'RP' and $prev_lex ne '((') #previous tag cannot be an RP in this case. and prep should be following something.
			{
	                        my $array_fs = &read_FS($feature,$sent);

				my @prev_vibhakti = &get_values_2("vib", $array_fs->[0],$sent); #get the post-position in the previous node's fs

				if($prev_vibhakti[0] eq ""){$new_vibhakti[0] = $lex;}
				else{$new_vibhakti[0] = $prev_vibhakti[0]."_".$lex;}

				#add this post-position to the previous node, eg. rAma ke kArana
				#&update_attr_val("vib", \@new_vibhakti, $array_fs);
				#update the case, just in case
				$new_case[0] = 1;
				#&update_attr_val("cas", \@new_case, $array_fs);
	
				#my $morph_string = &make_string($array_fs);
        	                #&modify_field( $node - 1, 4, $morph_string);
				#print stderr "############### $prev_vibhakti[0]\n";
		
				#&delete_node($node);                          #remove the parsarg node
                        	#$delete++;
			}
		}
	
		if($pos eq "NNP")
		{
			my $feature = &get_field($node, 4,$sent);
			my $array_fs = &read_FS($feature,$sent);
			#@attr_tree = &get_attributes($array_fs->[0]);
			###print stderr "attr---- @attr_tree\n";


			my $num_fs = &get_num_fs($array_fs,$sent);
			##print stderr "$node=================$feature=======================----------$num_fs-------@NNP_nodes\n";
			
			my $pos_next_node = &get_field($node+1, 3,$sent);

			#check if followed by PREP.
			if($pos_next_node eq "PREP"){$is_prep = 1; $par[0] = &get_field($node+1, 2);}else{$is_prep = 0;$par[0] = "0";}


			my @vib = &get_values_2("vib", $array_fs->[0],$sent);

			if($num_fs == 1 and $vib[0] eq "")	
			#if only one fs then update the value of case and num, no need to prune here, only update
			#also check if the vibhakti exists, in the next iteration after the vibhakti is added
			#the previous node becomes current and finds no prep and changes the case to 0
			{
				my @case;
				if($is_prep == 1)
				{
					$case[0] = 1;
					#&update_attr_val("vib",\@par,$array_fs);	#add the parsarg in the feature struct.
					#&delete_node($node+1);				#remove the parsarg node
					#$delete++;
				}
				else
				{
					$case[0] = 0;
					#&update_attr_val("vib",\@par,$array_fs);
				}

				$num[0] = "s";
				#&update_attr_val("cas",\@case,$array_fs);
				#&update_attr_val("num",\@num,$array_fs);
	
				#my $morph_string = &make_string($array_fs);
                	        #&modify_field( $node , 4 , $morph_string);
			}
			elsif($num_fs > 1)	#more than one will require pruning
			{
				@num_values = &get_values("num", $array_fs,$sent);
				####print stderr "I am hereNNP	@case_values	@num_values	@attr_tree\n";

				for(my $i = $#num_values; $i >= 0; $i--)	#prune based on number, proper noun cannot be plural
				{
					####print stderr "-###\n";
					if($num_values[$i] eq 'p')
					{
						$s_flag = &prune_FS("", $i, $array_fs,$sent);
				#		###print stderr "^^^^ $s_flag\n";
					}
				}

	#			$string = &make_string($array_fs);
				##print stderr "-------NNP------$string\n";
	#			@case_values = &get_values("cas", $array_fs,$sent);
				for(my $i = $#case_values; $i >= 0; $i--)	#prune based on case, check for parsarg(post-position)
				{
					if($case_values[$i] eq '1' and $is_prep == 0)
					{
						$s_flag = &prune_FS("", $i, $array_fs);
						##print stderr "--- $s_flag\n";
					}
					elsif($case_values[$i] eq '0' and $is_prep == 1)
					{
						$s_flag = &prune_FS("", $i, $array_fs);
						##print stderr "@@@ $s_flag\n";
					}
				}

				if($is_prep == 1)
                        	{
	                        #        &update_attr_val("vib",\@par,$array_fs);        #add the parsarg in the feature struct.
					####print stderr "$par[0]\n";
                	         #       &delete_node($node+1);                          #remove the parsarg node
				#	$delete++;
	                        }
				else
				{
				#	&update_attr_val("vib",\@par,$array_fs);
				}

				#my $morph_string = &make_string($array_fs);
				##print stderr "###FINAL FS#### $morph_string	$node\n";
                	        #&modify_field($node, 4, $morph_string);
			}
		}
		elsif($pos =~ /^NN/)#common nouns
		{
                	##print stderr "NODE=$node\n";


			my $feature = &get_field($node, 4,$sent);
			my $array_fs = &read_FS($feature,$sent);

			@attr_tree = &get_attributes($array_fs->[0],$sent);
			####print stderr "attr---- @attr_tree\n";
			@vibhakti = &get_values("vib", $array_fs,$sent);
			
			if($vibhakti[0] ne "")
			{
				next;
			}
			else
			{
		
				my $num_fs = &get_num_fs($array_fs);
			
				my $pos_next_node = &get_field($node+1, 3);
				if($pos_next_node eq "PREP")
				{
					$is_prep = 1;
					if($vibhakti[0] ne "")
					{
						$par[0] = $vibhakti[0]."_".&get_field($node+1, 2,$sent);
					}
					else{$par[0] = &get_field($node+1, 2);}
				}
				else{$is_prep = 0;$par[0] = "0";} #check if followed by PREP.

				##print stderr "$node ---- of NN--------------and it feature structure......$feature	del=$delete	#$num_fs\n";
				my @vib = &get_values_2("vib", $array_fs->[0],$sent);

				if($num_fs == 1 and $vib[0] eq "")	#if only one fs then update the value of case and num, no need to prune here
				{
					my @case;
					if($is_prep == 1)
					{	
						$case[0] = 1;
					#	&update_attr_val("vib",\@par,$array_fs);	#add the parsarg in the feature struct.
					#	&delete_node($node+1);				#remove the parsarg node
					#	$delete++;
					}
					else
					{
						$case[0] = 0;
					#	&update_attr_val("vib",\@par,$array_fs);
					}

	                        	#&add_attr_val("cas", \@case, $array_fs);
					#&update_attr_val("cas",\@case,$array_fs);

					#my $morph_string = &make_string($array_fs);
                	        	#&modify_field( $node , 4 , $morph_string);
				}
				else	#more than one, will require pruning
				{
					@case_values = &get_values("cas", $array_fs,$sent);
					##print stderr "I am here NN	@case_values	@attr_tree	$is_prep $#case_values\n";

					for(my $i = $#case_values; $i >= 0; $i--)	#prune based on case, check for parsarg(post-position)
					{						#start the loop from end (takes care of shifting of elements due to deletion.)
						###print stderr "###\n";
						if($case_values[$i] eq '1' and $is_prep == 0)
						{
							$s_flag = &prune_FS("", $i, $array_fs,$sent);
							##print stderr "$s_flag\n";
						}
						elsif($case_values[$i] eq '0' and $is_prep == 1)
						{
							$s_flag = &prune_FS("", $i, $array_fs,$sent);
							##print stderr "---$s_flag	$i\n";
						}
					}

					if($is_prep == 1)
        		                {
                		         #       &update_attr_val("vib",\@par,$array_fs);        #add the parsarg in the feature struct.
						###print stderr "$par[0]\n";
	                                #	&delete_node($node+1);                          #remove the parsarg node
					#	$delete++;
        	        	        }
					else
					{
						#&update_attr_val("vib",\@par,$array_fs);
					}
	
					#my $morph_string = &make_string($array_fs);
	#				##print stderr "$morph_string\n";
        	        	        #&modify_field( $node, 4, $morph_string);
				}
			}
		}
		else{}
	}

	#print "======================TREE_AFTER_PRUNE==================================\n";
#	&print_tree_file("prune_on_case.tmp");
}
1;
