use strict;
use warnings;
my @files = `ls $ARGV[0]`;
foreach my $file(@files){
	my ($sample,%seq,$iupac);
	my $n = 0;
	open(FA,"$ARGV[0]/$file") or die;
	while(<FA>){
		chomp;
		if(/^>(.*)/){
			$sample = $1;
			$n++;
		}else{
			$seq{$sample} = $_;
			#$iupac{$sample} = $seq{$sample} =~ tr/RYSWKM//;
		}
	}
	close(FA);
	my $count =0 ;
	foreach my $i(sort keys %seq){
		$iupac = $seq{$i} =~ tr/RYSWKM//;
		#print "$file\t$i\t$iupac";
		if($iupac == 0){
			$count++;
		}else{
			next;
		}
	}
	if($count == $n){
		print "$file";
	}
}
