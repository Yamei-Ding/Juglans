#author: Xu, Lin-Lin
use strict;
use warnings;
die ("
    Usage: perl fltDEP_xll_gz.pl <in.vcf.gz> <depth.list> <out.vcf> 
    in.vcf.gz : a raw in.vcf.gz made by GATK joint calling
    depth.list : this is a list with individual name and average depth,seperate is \\t ;and the individual name should be sort as the vcf's name order.
    out.vcf : a vcf file will be out put please give a name out.vcf. 
") unless scalar(@ARGV) == 3;

open IN,"gzip -dc $ARGV[0]|" or die; #read a raw vcf.gz made by GATK joint calling
#open IN,"$ARGV[0]" or die;  #if you have a file already unzipped ,please use this line.
open LI,"$ARGV[1]" or die; #this is a list with individual name and average depth,sep is \t ;and the individual should be sort as the vcfs individual order.
open OUT,">$ARGV[2]" or die; #this will output a vcf already filtered.

###read a individual depth list
my %list;
my $cou = 8;
while (<LI>){
	chomp;
	$cou++;
	my @it = split /\t/,$_;
	$list{$cou} = $it[1];
}
close LI;

###read your raw vcf file and change unqualified(depth <= 1/3 * aveDEP or depth >= 2 *aveDEP) site into ./.; if aveDEP < 18, it's (6,2 * ave DEP)
while (my $line =<IN>){
	chomp $line;
	if ($line =~ /^#/){
		print OUT "$line\n";
		next;
	}
	my @array = split /\t/,$line;
	foreach my $i (9 .. $#array){
		if ($array[$i] =~ /(.*?):(.*?):(\d+):/){
			my ($gtype,$ad,$dp) = ($1,$2,$3);
			my $min = $list{$i}*(1/3);
			if ($list{$i} <= 18){
				$min = 6;
			}
			my $max = $list{$i}*2;
			if ($dp <= $min || $dp >=$max ){
				$array[$i] =~ s/0\/1/\.\/\./g;
				$array[$i] =~ s/0\/0/\.\/\./g;
				$array[$i] =~ s/1\/1/\.\/\./g;
			}
		}
	}
	my $line2 = join("\t",@array);
	print OUT "$line2\n";
}
close IN;
