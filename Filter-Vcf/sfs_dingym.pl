#!/usr/bin/perl
use strict;
use warnings;
#Author: Ding, Ya-Mei
my $snp = 0;
my %sfs;
my $variance;
my @item;
my $ind;
my($vcf,$st,$ed) = @ARGV;
#$vcf is my join calling vcf file ,after filter
#$st is my pop start position in vcf filte
#$ed is my pop end position in vcf file
my $samples = $ed - $st +1; #the number of my pop individuals
my $copy = $samples*2; #the number of gene copies
open VCF,$vcf || die;
while(<VCF>){
chomp;
	$snp++;#the number of splits sites
	if(/^#/){
	next;
	}
	@item = split(/\t/,$_);
	$variance = 0; #the number of variance copys in that site
	foreach $ind ($st .. $ed){
		if($item[$ind] =~ /0\/0/){
			next;
		}elsif($item[$ind] =~ /0\/1/){
			$variance++;
		}elsif($item[$ind] =~ /1\/1/){
			$variance+=2;
		}else{
			print "find a missing!";
		}
	}
##################  make a folded SFS ############
	if($variance > $samples){
		$variance = $copy - $variance;
	}
	$sfs{$variance}++; #
}
close(VCF);
foreach my $key(sort {$a<=>$b} keys %sfs){
	print "$key\t$sfs{$key}\n";
}
