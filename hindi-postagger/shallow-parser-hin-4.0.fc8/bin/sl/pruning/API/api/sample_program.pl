#!/usr/bin/perl

require "shakti_tree_api.pl";

&read();

my($i,$f0,$f1,$f2,$f3,$f4);

# Form VGADV around VG
# Group the adverbs into VGADV (Maintain the same order)
$i = 1;
while($i!=-1)
{
	$f0 = &get_field($i,0);
	$f3 = &get_field($i,3);

	if($f3 eq "VG")
	{
		$vg_index=$i;
		$i=&create_parent($i,$i,"VGADV");
		$vg_index++;

		$p=$vg_index+1;
		while($p!=-1)
		{
			($f0,$f1,$f2,$f3,$f4) = &get_fields($p);
			print "HELLO p = $p $f4\n";
			if($f3 eq "RB" && $f2 ne "not")
			{
				&move_node($p,$vg_index,0);
				$vg_index+=$f0;
				$p+=$f0;
			}
			else
			{
				$p=&get_next_node($p);
			}
		}
	}
	elsif($f3 eq "RB")
	{
		&move_node($i,$vg_index,1);
		print "$i $vg_index\n";
		&print_tree;
		print "--------------\n";
		$i+=$f0;
		$vg_index+=&get_field($vg_index,0);
	}

	$i=&get_next_node($i);
}

@array=&get_nodes_pattern(3,"V.*");
print "@array\n";

&print_tree;
