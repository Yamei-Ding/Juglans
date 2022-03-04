#!/user/bin/perl -w
use strict;
use warnings;
use Getopt::Std;

#Date:2019.03.14
#Author: zhangbw Linan xull*
#beta
my %opts = (m=>10,M=>60,S=>0,s=>100000,A=>0,l=>'',r=>0);
getopts('BNDm:M:QS:A:l:r:s:',\%opts);
die("
Filtering_SNP_BNU beta1.0

Usage:  fltVCF_xll.pl [options] <in.vcf> <out.vcf> 2>prefix.log\n
Options: -B        remove non biallele sites
	 -N        remove missing data
	 -D        filter depth (need -m -M )
	 -m INT    minimum depth [$opts{m}] recommend : 1/3 * average depth
	 -M INT    maximum depth [$opts{M}] recommend : 2 * average depth
	 -Q        adjust allele frequency by depth (chi-square test)
	 -S INT    choose SNP by (INT bp) interval(need -l & -r & -s) [$opts{S}]
	 -s INT    minimum reference scaffold length [$opts{s}bp]
	 -l FILE   length file of reference sequence (made by lengthfa.pl) [$opts{l}]
	 -r FLOAT  a random number in [0,1] to choose SNP (if you want all just use 0;if u want 80% SNP to be reserve use 0.2)[$opts{r}] 
	 -A FLOAT  minimum allele frequency (need -N) [$opts{A}]

Notice : 1.in.vcf should be a jointcalling vcf made by sentieon.
	 2.If you need choose SNP by interval make sure you use -l -s -r ,don't miss any of them.

Guide : step1 : whole genome high quality SNP
		fltVCF_xll.pl -B -Q -D -m -M <in.vcf> <out.vcf> 2>prefix.log
	step2 : independent non-missing SNP 
		fltVCF_xll.pl -N -S -s -l -r <in.vcf> <out.vcf> 2>prefix.log
	step3 : do MAF
		fltVCF_xll.pl -A <in.vcf> <out.vcf> 2>prefix.log
	notice: run it step by step will be more helpful! Good luck ~.~

\n")if (@ARGV < 2);

open IN,$ARGV[0] or die;
open OUT,">$ARGV[1]" or die;

my (%ratio_sfs,%unfolded_sfs);###make folded and unfolded SFS
#####choose SNP by interval (S)#####################################################################################################################################################################################################
my @lens if ($opts{l} ne '');
my %vcf if ($opts{l} ne '');
if ($opts{l} ne ''){
	open LENGTH,$opts{l} or die;
	while (<LENGTH>){
		chomp;
		next unless (/^>/);
		s/>//g;
		my @l =split (/\t/);
		next if ($l[1] < $opts{s});
		push @lens,$l[0];
	}
	close LENGTH;
}
####################################################################################################################################################################################################################################
my ($count_B,$count_N,$count_D,$count_Q,$count_S,$count_A,$sample_n)=(0,0,0,0,0,0,0);
while (my $line =<IN>){
	chomp $line;
	if ($line =~ /^#/){
		print OUT "$line\n";next;
	}
	my @array = split /\t/,$line;
	$sample_n = $#array-8;
	my ($biallele,$missing,$quality,$hom,$hep) = (0,0,0,0,0);
	if (defined($opts{B})){
		if (length($array[3]) >= 2 || length($array[4]) >= 2){
			$biallele = 1;$count_B++;next;
		}
	}
	my ($dlens,$lowmaf,$highmaf,$het,$maf) = (0,0,0,0,0);
	$dlens = $sample_n * 2;
	$lowmaf = $dlens * $opts{A};
	$highmaf = $dlens - $lowmaf;
	foreach my $i (9 .. $#array){
		if ($array[$i] =~ /(.*?):(.*?):(\d+):/){
			my ($gtype,$ad,$dp) = ($1,$2,$3);
			if (defined($opts{D})){
				if ($dp <= $opts{m} || $dp >=$opts{M} ){
					$array[$i] =~ s/0\/1/\.\/\./g;
					$array[$i] =~ s/0\/0/\.\/\./g;
					$array[$i] =~ s/1\/1/\.\/\./g;
					$gtype = './.';
					$count_D++;
				}
			}
			if (defined($opts{N})){
				if ( $gtype eq './.'){
					$missing = 1;$count_N++;last;
				}
			}
			if (defined($opts{Q})){
				if ($gtype eq '0/1'){
					my @ap = split /\,/,$ad;
					my ($limit_1,$limit_2) = (0.1 * $dp,0.9 * $dp);
					if($dp >= 20){
				  		($limit_1,$limit_2) = (0.2 * $dp,0.8 * $dp);
					}
                        		if ( $ap[0] >= $limit_2 ){
                                		$array[$i] =~ s/0\/1/0\/0/g;
						$gtype =~ s/0\/1/0\/0/g;
						$count_Q++;
                        		}elsif( $ap[0] <= $limit_1 ){
						$array[$i] =~ s/0\/1/1\/1/g;
						$gtype =~ s/0\/1/1\/1/g;
						$count_Q++;
					}
				}
				$hep++ if ($gtype eq '1/1');
				$hom++ if ($gtype eq '0/0');
			}
			next if ($gtype eq '0/0');
			$het++ if ($gtype eq '0/1');
			$het = $het + 2 if ($gtype eq '1/1');
		}
	}
	my $line2 = join("\t",@array);
	$unfolded_sfs{$het}++;
	if ($het <= $sample_n){
		$ratio_sfs{$het}++;
	}else{
		my $tmp = $dlens - $het;
		$ratio_sfs{$tmp}++;
	}
	if ($opts{A} != 0 && ($het < $lowmaf || $het > $highmaf)){
		$maf = 1;$count_A++;
	}
	$quality = 1 if (defined($opts{Q}) && ($hep >= $sample_n || $hom >= $sample_n));
	if ($biallele == 0 && $missing == 0 && $quality == 0 && $maf == 0){
		if ($opts{l} ne ''){
			$vcf{$array[0]}{$array[1]} = $line2;
		}else{
			print OUT "$line2\n";
		}
	}	 
}
close IN;
#####choose SNP by interval (S)#####################################################################################################################################################################################################
if ($opts{l} ne ''){
	foreach my $j (0 .. $#lens){
		next unless ($vcf{$lens[$j]});
		my $cn = 0;
		foreach my $key (sort {$a<=>$b} keys %{$vcf{$lens[$j]}}){
			my $cha = $key - $cn;
			my $rd = rand();
			if ($cha > $opts{S} && $rd >= $opts{r}){
				print OUT "$vcf{$lens[$j]}{$key}\n";
				$count_S++;
				$cn = $key;
			}
		}	
	}
}
close OUT;
#####print SNP or sites be filtered or keeped######################################################################################################################################################################################
print STDERR "filtered biallele SNP(B) : $count_B\nfiltered missing SNP(N) : $count_N\nadjusted depth sites(D) : $count_D\nadjusted allele frequency sites(Q) : $count_Q\nkeeped choose by interval SNP(S) : $count_S\nfiltered MAF SNP(A) : $count_A\n";
#####calculate SFS and PI(variant)#################################################################################################################################################################################################
print STDERR "foldedSFS:\n";
foreach my $k (sort {$a<=>$b} keys %ratio_sfs){
	print STDERR "$k\t$ratio_sfs{$k}\n";		
}
print STDERR "unfoldedSFS:\n";
my $sfssum = 0;
foreach my $sfs (sort {$a<=>$b} keys %unfolded_sfs){
	print STDERR "$sfs\t$unfolded_sfs{$sfs}\n";
	next if ($sfs == 0);
	my $tmpsum = 2 * $sample_n;
	next if ($sfs == $tmpsum);
	$sfssum = $sfssum + $unfolded_sfs{$sfs};
}
my $denominator = $sample_n * (2 * $sample_n - 1);
my $numerator = 0;
foreach my $sfs (sort {$a<=>$b} keys %unfolded_sfs){
        next if ($sfs == 0);
	my $sfstmp = ($unfolded_sfs{$sfs}/$sfssum) * $sfs * (2 * $sample_n - $sfs);
        $numerator = $numerator + $sfstmp;
}
my $pi = $numerator/$denominator;
print STDERR "PI(var)(Tajima 1989) : $pi\n";
#####END############################################################################################################################################################################################################################
