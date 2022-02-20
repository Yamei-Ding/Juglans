use strict;
use warnings;
sub help{
	print "perl xxx.pl Jre-C1.list Jre-C2.list phase_dir select_dir\n";
	print "perl check_good_loci.pl ../../data_Fraxinus/2021-Phase/NC.list ../../data_Fraxinus/2021-Phase/JP.list 52ind-phased/ test-phase\n";
}
sub list{
	my ($file) = @_;
	open(IN,$file) or die;
	my @ind;
	while(<IN>){
		chomp;
		my $tmpa = "${_}a";
		my $tmpb = "${_}b";
		push @ind,$tmpa;
		push @ind,$tmpb;
	}
	close(IN);
	return @ind;
}
sub read{
	my ($file) = @_;
	open(IN,$file) or die;
	my %seq;
	my $ind;
	while(<IN>){
		chomp;
		if(/^>(.*)/){
			$ind = $1;
		}else{
			$seq{$ind} .= $_;
		}
	}
	close(IN);
	return \%seq;
}
sub check{
	my ($file) = @_;
	open(IN,$file) or die;
	my %seq;
	my $ind;
	while(<IN>){
		chomp;
		if(/^>(.*)/){
			$ind = $1;
		}else{
			$seq{$ind} .= $_;
		}
	}
	close(IN);
	my $bed=0;
	my $bed_count=0;
	my $num=0;
	my $boot = "T";
	foreach my $i(sort keys %seq){
		$bed = $seq{$i} =~ tr/RYWSKM//;
		$num++;
		if($bed > 0){
			$bed_count++;
		}
	}
	if($bed_count > $num*0.1){
		$boot = "F";
	}
	return $boot;
}
if($ARGV[0] eq "-h"){
	&help;
}else{
	my @C1 = &list($ARGV[0]);
	my @C2 = &list($ARGV[1]);
	`rm -rf $ARGV[3]`;
	`mkdir -p $ARGV[3]`;	
	my @files = split(/\n/,`ls $ARGV[2]`);
	foreach my $file(@files){
		my $boot = &check("$ARGV[2]/$file");
		my %count_C1;##check the whethe the polymorphsim loci
		my %count_C2;##check the whethe the polymorphsim loci;
		my %bed_ind;
		if($boot eq "T"){
			my $seq = &read("$ARGV[2]/$file");
			foreach my $i(@C1){
				my $bed = $$seq{$i} =~ tr/RYWSKM//;
				if($bed > 0){
					$bed_ind{$i} = "bed";
					#next;
				}else{
					$count_C1{$$seq{$i}}++;
				}
			}
			foreach my $i(@C2){
				my $bed = $$seq{$i} =~ tr/RYWSKM//;
				if($bed > 0){
					$bed_ind{$i} = "bed";
					#next;
				}else{
					$count_C2{$$seq{$i}}++;
				}
			}
			#foreach my $i(@JP){
			#	$count_JP{$$seq{$i}}++;
			#	$count_JP{$$seq{$i}}++;
			#}
			my $test_c1 = keys %count_C1;
			my $test_c2 = keys %count_C2;
			if($test_c1 > 1 && $test_c2 >1){
				open(OUT,">>$ARGV[3]/$file") or die;
				foreach my $i(@C1){
					if(!exists $bed_ind{$i}){
						print OUT ">$i\n$$seq{$i}\n";
					}		
				}
				foreach my $i(@C2){
					if(!exists $bed_ind{$i}){
						print OUT ">$i\n$$seq{$i}\n";
					}		
				}
			}
		}
	}
}

