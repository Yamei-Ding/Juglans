#!/usr/bin/perl
use strict;
use warnings;
#use Getopt::Std;
#Author: Zhang, Bo-Wen
#get file names
&usage() unless scalar(@ARGV) == 4;
my ($fasta,$pos,$delfile,$out)=@ARGV;
#my $pos=$ARGV[1];
#$pos input filter snp file
my %iupac = (
	'A,G'=>'R',
	'C,T'=>'Y',
	'G,C'=>'S',
	'A,T'=>'W',
        'G,T'=>'K',
        'A,C'=>'M',

        'G,A'=>'R',
        'T,C'=>'Y',
        'C,G'=>'S',
        'T,A'=>'W',
        'T,G'=>'K',
        'C,A'=>'M',
);

open FA,"$fasta" ||die "cannot open $fasta $!\n";
my %seq;
my $id;
while (<FA>){
        chomp;
        if (/^>(.*)/){
	#	s/>(\S+)//;
		$id=$1;
	}else{
		$seq{$id}.=uc($_);
	}
}


open PO,"$pos" || die "cannot open $pos $!\n";
while (<PO>){
	next if (/^#/);
	next if (/INDEL/);
	chomp;
	my @item=split(/\t/);
	my $len=length($item[3]);
	next if ($len > 1);
	#next if (length($item[4]) > 1);
	my $pos=$item[1]-1;
#	if ($item[4] =~ /\,/ && $item[9] =~ /^1\/2/){
#		if(substr($seq{$item[0]},$pos,$len) ne $item[3]){
 #                       print STDERR "something wrong\n$_\n".substr($seq{$item[0]},$pos,$len)." not equal to $item[3]\n";
 #               }
#		substr($seq{$item[0]},$pos,$len) = $iupac{$item[4]};
#	}
	if (length($item[4]) > 1){
		substr($seq{$item[0]},$pos,$len) = "N";
		next;
		}
	elsif ($item[9] =~ /^1\/1/){
		if(substr($seq{$item[0]},$pos,$len) ne $item[3]){
		print STDERR "something wrong\n$_\n".substr($seq{$item[0]},$pos,$len)."not equal to $item[3]\n";
		}
		substr($seq{$item[0]},$pos,$len) = $item[4];
	}
	elsif ($item[9] =~ /^0\/1/){
		if(substr($seq{$item[0]},$pos,$len) ne $item[3]){
		print STDERR "something wrong\n$_\n".substr($seq{$item[0]},$pos,$len)."not equal to $item[3]\n";
                }
		my @dp = $item[7] =~ /DP4=(\d+),(\d+),(\d+),(\d+)/;
		#my $ref = $dp[0]+$dp[1];
                #my $alt = $dp[2]+$dp[3];
                my $all = $dp[0] + $dp[1] + $dp[2] + $dp[3];
		my $alt = ($dp[2]+$dp[3])/$all;
		my $ref = ($dp[0]+$dp[1]) /$all;
		next if( $all < 6);
		if($all >= 20){
		  next if( $alt <= 0.2);
		  if( $ref <= 0.2){
			substr($seq{$item[0]},$pos,$len) = $item[4];
			next;
		  }
		  substr($seq{$item[0]},$pos,$len) = $iupac{"$item[3],$item[4]"};
		}else{
		  next if( $alt <= 0.1);
		  if( $ref <= 0.1){
                        substr($seq{$item[0]},$pos,$len) = $item[4];
                        next;
                  }
		  substr($seq{$item[0]},$pos,$len) = $iupac{"$item[3],$item[4]"};
		}
	}
} #end of while
close PO;

open DEL,"$delfile" || die "cannot open $delfile $!\n";
while(<DEL>){
	chomp;
	next if (/^#/);
         next if (/INDEL/);
         my @item=split(/\t/);
	my $pos = $item[2] - 1;
	substr($seq{$item[1]},$pos,1) = 'N';
}
close DEL;

open OUT,">$out" || die "cannot write into $out: $!\n";

while(my ($k,$v) = each %seq){
        $v=~s/(\D{100})/$1\n/g;
        print OUT ">$k\n$v\n";
}
close OUT;

sub usage{
	print "
USAGE:
perl consensus.pl fasta_file vcf_file output_file

EXAMPLE:
perl consensus.pl test.fa test.vcf out.fa
";
die;
}
