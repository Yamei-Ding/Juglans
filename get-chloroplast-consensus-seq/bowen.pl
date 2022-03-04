#!/usr/bin/perl
use strict;
use warnings;

#get file names
&usage() unless scalar(@ARGV) == 4;
my $fasta=$ARGV[0]; #reference cpgenome fasta
my $pos=$ARGV[1]; #variation site  infor file
my $dels=$ARGV[2];
my $seqID=$ARGV[3];
my $depth=$ARGV[4];
my $nn=0;
my $rn=0;
my $mn=0;
my %base;  #we name the hash at first.

open PO,"$pos" || die "cannot open $pos $!\n";
while (<PO>){  #here we save the positions that need to be changed into our hash.
	next if (/^#/);
	next if (/INDEL/);
	chomp;
	my @item=split(/\t/);
	my $len=1; #length($item[3]);
	#filter by DP and DP4:
	
	my @dp4 = $item[7] =~ /DP4=(\d+),(\d+),(\d+),(\d+)/;
	my $dpref=$dp4[0]+$dp4[1];
	my $dpalt=$dp4[2]+$dp4[3];
	#print STDERR "ref = $dpref, alt = $dpalt\n";
	if ($item[4] =~ /\,/){
		print STDERR "TWOALT:$item[1],$item[3],$dpref,$item[4],$dpalt\n";
		$base{$item[1]}="1,N";
		next;
	}
	if($item[9] =~ /^1\/1/){
		$base{$item[1]}="1,$item[4]";
	}elsif($item[9] =~ /^0\/1/){
		my @dp4 = $item[7] =~ /DP4=(\d+),(\d+),(\d+),(\d+)/;
		my $dpref=$dp4[0]+$dp4[1];
		my $dpalt=$dp4[2]+$dp4[3];
		my $all = $dpref + $dpalt;
		if (($dpref/$all) < 0.20){
			$nn++;
			$base{$item[1]}="1,$item[4]";
		}elsif (($dpref/$all) > 0.8){
		$rn++;
		$base{$item[1]}="1,$item[3]";
		}else{
			if (($dpref+$dpalt)>$depth){
		  	  $mn++;
		  	  print STDERR "HETEROZIGOSITY in CHL?:$item[1],$item[3],$dpref,$item[4],$dpalt\n";
			}
		$base{$item[1]}="1,N";
		}
	}
} #end of while
close PO;
print STDERR "alter: $nn,ref: $rn,diploid: $mn\n";

open DEL,$dels || die "cannot open $dels $!\n";
while(<DEL>){
	chomp;
	next if (/^#/);
        next if (/INDEL/);
        my @item=split(/\t/);
	$base{$item[2]}="1,N";
}
close DEL;

my $current_seq;
my $current_name=$seqID;
#$current_name =~ s/\.mem\.//;

open FA,"$fasta" ||die "cannot open $fasta $!\n";

while (<FA>){
	chomp;
	if (/^\>/){  #it is the title
		#$current_name=$_;
		$current_seq="";
		}
	else{  #it is the sequence
		$current_seq.="$_";
	}
}
#deal the last seq
&replace($current_name,$current_seq,%base);
close FA;
print "\n";

sub replace {
	my ($name, $seq, %hash) = @_;
	while (my ($k,$v)=each %hash){
		my ($len,$target)=split(/\,/,$v);
		substr($seq,$k-1,$len)=$target;
	}
	$seq=~s/(\D{70})/$1\n/g;
	print "\>$name\n$seq\n";
}

sub usage{
	print "
USAGE:
perl bowen.pl fasta_file position_file >output_file

EXAMPLE:
perl bowen.pl test.fa pos.txt >out.fa
"
}
