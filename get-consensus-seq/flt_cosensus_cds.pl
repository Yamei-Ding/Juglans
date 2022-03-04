use warnings;
use strict;
#Author Ding, Ya-Mei
my %hash = ();
my ($start,$end,$mask,$len);
my ($l_file,$fasta,$gff,$out,$step) = @ARGV;#step <bp>
my $l_hash;
my $id;
my %seq;
open IN,$l_file or die;
	while(<IN>){
		chomp;
		next if (/^ID/);
		s/>//g;
		my @it = split /\t/,$_;
		$hash{$it[0]} = $it[1];
	}
close IN;
$l_hash = \%hash;

open FA,$fasta or die;
while(<FA>){
	chomp;
	if(/^>(.*)/){
		$id = $1;
	}else{
		$seq{$id} .= $_;
	}
}
close(FA);

open GFF,$gff;
while (<GFF>){
	chomp;
	next if(/^#/);
        my @it = split /\t/,$_;
        if ($it[2] eq "CDS"){
			if (exists $l_hash->{$it[0]}){
				if ($it[3] - $step > 1){
					$start = $it[3] - $step;
				}else{
					$start = 1;
				}
				if ($it[4] + $step < $l_hash->{$it[0]}){
					$end = $it[4] + $step;
				}else{
					$end = $l_hash->{$it[0]};
				}
			$start = $start -1;
                	$len = $end - $start;
			$mask = "N" x $len;
			substr($seq{$it[0]},$start,$len) = $mask;
			print "$it[0]\t$start\t$end is good\n";
			}
		}
}
close(GFF);
open OUT,">$out" or die;
foreach my $k (sort keys %seq){
	my $v = $seq{$k};
	print OUT ">$k\n$v\n";
}
