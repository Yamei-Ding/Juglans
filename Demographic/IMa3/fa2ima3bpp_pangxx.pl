#!/usr/bin/perl -w
###author: Pang, X. X, pangxiaoxu@mail.bnu.edu.cn
##Date: 2021-11-24
use strict;
use Getopt::Std;
my %opt;
&getopts("p:m:o:i:h",\%opt);
if(!exists $opt{p} || !exists $opt{m} || !exists $opt{o} || !exists $opt{i})
{
	print "perl xxx.pl -p path -m map -o outfile -i [1/2]\n";
	print "format for outfile: 1:BPP\t2:IMA3\n";
	exit;
}
my %map;
my @order;
open (MAP,$opt{m})or die;
while(<MAP>)
{
	if(/(\S+)\s+(\S+)/)
	{
		$map{$1}=$2;
		push @order,$1;
	}
}
close(MAP);

open (FILE,">$opt{o}")or die;
my @files=split/\n/,`ls $opt{p}`;
foreach my $f(@files)
{
	if($f=~/loci(\d*).fasta/)
	{
		my $loci=$1;
		my %seq;
		my %num;
		$/=">";
		open (FA,"$opt{p}/$f")or die ;
		while(<FA>)
		{
			chomp;
			if(/^((\S+)[ab])\n(\S+)/)
			{
				my ($id,$name,$seq)=($1,$2,$3);
				$seq{$id}=$seq;
				if($map{$name} eq "Jre1"){$num{"Jre1"}++;}
				if($map{$name} eq "Jre2"){$num{"Jre2"}++;}
				if($map{$name} eq "Jsi"){$num{"Jsi"}++;}
			}
		}
		close(FA);
		$/="\n";
		my @t=keys %seq; my $len=length($seq{$t[0]});
		if($opt{i} == 1)
		{
			print FILE $num{Jre1}+$num{Jre2}+$num{Jsi}."\t$len\n";
			foreach my $i(@order){
					my $ida = "${i}a";
					my $idb = "${i}b";
				if(exists $seq{$ida} && exists $seq{$idb}){
					print FILE "loci$loci^$ida\t$seq{$ida}\n";
					print FILE "loci$loci^$idb\t$seq{$idb}\n";		
				}
			}
		}
		if($opt{i} == 2)
		{
			print FILE "loci$loci $num{Jre1} $num{Jre2} $num{Jsi} $len H 1.0 ".1.54e-9*$len."\n";
			#foreach my $id (sort keys %seq)
			foreach my $i(@order){
					my $ida = "${i}a";
					my $idb = "${i}b";
				if(exists $seq{$ida} && exists $seq{$idb}){
					print FILE "$ida $seq{$ida}\n";
					print FILE "$idb $seq{$idb}\n";
				}
			}
		}
	}
}
close(FILE);
