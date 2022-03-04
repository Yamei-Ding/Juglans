#!/usr/bin/perl -w
use strict;
use Data::Dumper;
##author: Yan, Peng-Cheng
#perl xxx.pl sample1.fa sampl2.fa samplen.fa out
my $N50 = 100000; #minmum scaffold length
my $window = 20000; #up to you, LD 
my $loci_len = 1000; #up to you
my $max_numN = 5; # number of N in loci 
my $randStart = int(rand(13)*100);
my $sample = $#ARGV;

my @SA;
for(my $i=0;$i<$sample;$i++){
	$SA[$i] = &getSeqByName($ARGV[$i],$N50);
}

my $out = $ARGV[$#ARGV];
my $ind = $#ARGV;
my %locus;

foreach my $l(sort keys %{$SA[0]}){
	my $ll = length($SA[0]->{$l});
	my $where = $randStart;
	while($where < $ll-$loci_len){
		my $seq1 = substr($SA[0]->{$l},$where,$loci_len);
		my $seqN = '';
		my $NN = 0;
		my $same = 1;
		my $seq1N = $seq1 =~ tr/[Nn]//;
		my $maxNN = $seq1N;
		for(my $si=1;$si<$sample;$si++){
			$seqN = substr($SA[$si]->{$l},$where,$loci_len);
			$same=1 if($seq1 ne $seqN);
			$NN = $seqN =~ tr/[Nn]//;
			$maxNN = $NN if($NN > $maxNN); 
		}
		if($same == 0 || $maxNN > $max_numN){
			$where += $loci_len;
		}else{
			push @{$locus{$l}}, $where;
			$where += $loci_len;
		}
	}
}

my $printOUT = '';
my $i = 0;
my $total = $i*$loci_len;
foreach my $lo(keys %locus){
	my $pre = -99999;
	for(my $s=0;$s<@{$locus{$lo}};$s++){
		if(($locus{$lo}->[$s] - $pre +1) > $window){
		$i++;
		$printOUT .= "loci$i $ind $loci_len\n";
		for(my $j=0;$j<$ind;$j++){
			#print length($SA[$j]->{$c})."\t$j\t$c\n";
			my $seq = substr($SA[$j]->{$lo},$locus{$lo}->[$s],$loci_len);
			$printOUT .= "I$j $seq\n";
		}
		}
		$pre = $locus{$lo}->[$s];
	}
}

my $locusN = $i;
open OUT,">$out.txt";
print OUT "$locusN\n$printOUT";
close OUT;
print "$total\n";

open IN,"sample-control-file.ctl";
open OUT,">$out.ctl";
while(<IN>){
	s/mcmc\.log/$out\.mcmc.log/ if(/mcmc\.log/);
	s/seqs-sample\.txt/$out\.txt/ if(/seqs-sample\.txt/);
	print OUT $_;
}
close OUT;
close IN;
exit;
#`~/software/G-PhoCS/bin/G-PhoCS-1-2-3 $out.ctl`;

sub getSeqByName(){
	my $file = shift;
	my $length = shift;
	my $seq = '';
	my %hash;
	my $sepOrign = $/;
	$/ = "\n>";
	open(IN,$file)||die"Can not open the file $file\n";
	while(<IN>){
		chomp;
		if(/^(.*?)\n(.*)/s){
			my $name = $1;
			my $rs = $2;
			#$name =~ s/\s.*//g;
			#$name =~ s/\|.*//g;
			$name =~ s/ /_/g;
			$name =~ s/>//;
			$seq = $rs;
			$seq =~ s/[\n|>| ]//sg;
			if(length($seq)>=$length){
				$hash{$name} = $seq;
			}
		}
	}
	close IN;
	$/ = $sepOrign;
	return \%hash;
}
