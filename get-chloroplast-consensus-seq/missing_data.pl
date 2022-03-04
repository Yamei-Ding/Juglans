#!/usr/bin/perl
use strict;
use warnings;

#get file names
&usage() unless scalar(@ARGV) == 4;
my $fasta=$ARGV[0];
my $pos=$ARGV[1];
my $limit=$ARGV[2];
my $out=$ARGV[3];
my $genome_size="160537";#160579";
my $outdir="final_consensus";
my $nn=0;
my %base;  #we name the hash at first.
my $csite=0;
open PO,"$pos" || die "cannot open $pos $!\n";
while (<PO>){  #here we save the positions that need to be changed into our hash.
	next if (/^#/);
	chomp;
	my @item=split(/\t/);
	if ($item[1] > ($csite + 1)){
		my $st = $csite + 1;
		my $ed = $item[1] - 1;
		foreach my $nc ($st .. $ed){
			$base{$nc}="1,N";
			$nn++;
		}
	}
	$csite=$item[1];
	my $len=1; #length($item[3]);
	my $dp = $item[2];
	if ( $dp < $limit ){ 
	#	print STDERR "$item[1]\n";
		$base{$item[1]}="1,N";
		$nn++;
		next;
	}
} #end of while
close PO;
if ($csite < $genome_size){
	my $st = $csite + 1;
	my $ed = $genome_size;
	foreach my $nc ($st .. $ed){
        	$base{$nc}="1,N";
		$nn++;
	}
}
#my $seq_name=$pos;
print STDERR "total MISSING = $nn\n";
my $current_seq;
my $current_name=$out;
#$current_name =~ s/\.\/flt_vcfs\///;
`mkdir -p $outdir`;
open OUTFA,">./$outdir/$out.flt.fasta" || die "cannot write into $!\n";
open FA,"$fasta" ||die "cannot open $fasta $!\n";

while (<FA>){
	chomp;
	if (/^\>/){  #it is the title
		$current_seq="";
		}
	else{  #it is the sequence
		$current_seq.="$_";
	}
}
#deal the last seq
&replace($current_name,$current_seq,%base);
close FA;

close OUTFA;

sub replace {
	my ($name, $seq, %hash) = @_;
	while (my ($k,$v)=each %hash){
		my ($len,$target)=split(/\,/,$v);
		substr($seq,$k-1,$len)=$target;
	}
	$seq=~s/(\D{70})/$1\n/g;
	print OUTFA "\>$name\n$seq\n";
}

sub usage{
	print "
USAGE:
perl bowen.pl fasta_file position_file >output_file

EXAMPLE:
perl bowen.pl test.fa pos.txt >out.fa
"
}
