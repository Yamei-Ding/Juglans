#!/usr/bin/perl
use warnings;
use strict;
my $data;
my $count = 0;
my $rate;
my $long;
open(FAS,"$ARGV[0]") or die;
open(OUT,">>missing_rate.txt") or die;
while(<FAS>){
chomp;
	if(/^>/){
	next;
	}
	else{
	$data .= $_;
	$count += tr/N//;
	}
}
$long = length($data);
$rate = $count/$long;
#print OUT "filename\ttotal length\t$count\tmissing rate\n";
print OUT "$ARGV[0]\t$long\t$rate\n";
close(FAS);
close(OUT);
