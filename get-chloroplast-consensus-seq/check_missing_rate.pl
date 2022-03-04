use strict;
use warnings;
sub help{
	print "perl xxx.pl seq_dir/ \n";
}
if($ARGV[0] eq "-h"){
	&help;
}else{
	my @files = split(/\n/,`ls $ARGV[0]`);
	my %missing;
	foreach my $file(@files){
		open(FA,"$ARGV[0]/$file") or die;
		my $ind;
		my %seq;
		while(<FA>){
			chomp;
			if(/^>(.*)/){
				$ind  = $1;
			}else{
				$seq{$ind} .= $_;
			}
		}
		close(FA);
		my $num_N = 0;
		foreach my $i (sort keys %seq){
			$num_N = $seq{$i} =~ tr/N//;
			$missing{$i} = $num_N;
		}
	
	}
	foreach my $i(sort {$missing{$b} <=>$missing{$a}} keys %missing){
		print "$i\t$missing{$i}\n";
	}
}
