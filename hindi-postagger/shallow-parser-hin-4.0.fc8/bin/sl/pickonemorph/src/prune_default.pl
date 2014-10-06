#!/usr/bin/perl
sub prune_default{


	# Keep the first FS in the case of more than one
	$sent=@_[0];
	my($parent);
	my($fs,@attr,@index);
	@index = &get_leaves($sent);
	
	for($i=0 ; $i<=$#index ; $i++)
	{
		($f0,$f1,$f2,$f3,$f4) = &get_fields($index[$i],$sent);
		$fs_ptr = &read_FS($f4,$sent);

		#first, update all the category in the FS based on the POS

		$num_of_fs = &get_num_fs($fs_ptr,$sent);
		if($num_of_fs > 1)
		{
			for($j = 2; $j <= $num_of_fs; $j++)
			{
				$ret=&prune_FS("",$j,$fs_ptr,$sent);
			}
		}

		$string=&make_string($fs_ptr,$sent);
		&modify_field($index[$i],4,$string,$sent);
	}
}

1;
