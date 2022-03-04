#!/usr/bin/perl
my ($l_file,$fasta,$depfile,$lmtd,$lmtD)=@ARGV;
$lmtD = 100 unless($lmtD);
print STDERR "depth: >$lmtd and <$lmtD\n";
my %seqs;
my $id;
my %scaf;
my @infor;
open LF,"$l_file" || die "$!\n";
while(<LF>){
	chomp;
	next if(/^ID/);
	s/>//g;
	@infor = split(/\t/,$_);
	$scaf{$infor[0]} = $infor[1];
}
close(LF);
open FA,"$fasta" || die "$!\n";
while(<FA>){
	chomp;
	if(/>(.*)/){
	#	s/>//g;
		$id=$1;
	}else{
#		s/\s//g;
		$seqs{$id} .= $_;
	}
}
close FA;

open DEP,"$depfile" || die "$!\n";
while(<DEP>){
	chomp;
	next if (/^\#/);
	my @it = split(/\t/);
	if( $it[1] <= $scaf{$it[0]}){
		my $st = $it[1] - 1;
		next unless($seqs{$it[0]});
		if($it[2] <= $lmtd || $it[2] >= $lmtD){
		  substr($seqs{$it[0]},$st,1) = "N";
		}
	}else{
		next;
	}
}
close DEP;
foreach my $k (sort keys %seqs){
	my $v = $seqs{$k};
	print ">$k\n$v\n";
}
