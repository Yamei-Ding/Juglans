use strict;
use warnings;
sub help{
	print "perl xxx.pl Jsi.list phase_dir select_dir\n";
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
	my @jsi = &list($ARGV[0]);
	`rm -rf $ARGV[2]`;
	`mkdir -p $ARGV[2]`;	
	my @files = split(/\n/,`ls $ARGV[1]`);
	foreach my $file(@files){
		my $boot = &check("$ARGV[1]/$file");
		my %count_jsi;
		my %bed_ind;
		if($boot eq "T"){
			my $seq = &read("$ARGV[1]/$file");
			foreach my $i(@jsi){
				my $bed = $$seq{$i} =~ tr/RYWSKM//;
				if($bed > 0){
					$bed_ind{$i} = "bed";
					#next;
				}else{
					$count_jsi{$$seq{$i}}++;
				}
			}
			#foreach my $i(@JP){
			#	$count_JP{$$seq{$i}}++;
			#	$count_JP{$$seq{$i}}++;
			#}
			my $test_jsi = keys %count_jsi;
			if($test_jsi > 1){
				open(OUT,">>$ARGV[2]/$file") or die;
				foreach my $i(@jsi){
					if(!exists $bed_ind{$i}){
						print OUT ">$i\n$$seq{$i}\n";
					}		
				}
				close(OUT);
			}
		}
	}
}

