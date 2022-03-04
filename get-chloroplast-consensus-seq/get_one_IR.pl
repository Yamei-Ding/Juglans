use strict;
use warnings;
sub help{
	print "pelr xxx.pl input.fa IR1_ed_pos out_dir\n";
}
if($ARGV[0] eq "-h"){
	&help;
}else{
	my $pos = $ARGV[1];
	my @files = split(/\n/,`ls $ARGV[0]`);
	foreach my $file(@files){
		open(FA,"$ARGV[0]/$file") or die;
		my $ind;
		my %seq;
		while(<FA>){
			chomp;
			if(/^>(.*)/){
				$ind = $1;
			}else{
				s/[RYWSKM]/N/g;
				$seq{$ind} .= uc($_);
			}
		}
		close(FA);
		`mkdir -p $ARGV[2]`;
		open(OUT,">>$ARGV[2]/$file") or die;
		foreach my $i(sort keys %seq){
			my $tmp = substr($seq{$i},0,$pos);
			print OUT ">$i\n$tmp\n";
		}	
		close(OUT);
	}
}
