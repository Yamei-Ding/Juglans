use strict;
use warnings;
sub help{
	print "pelr xxx.pl mix.vcf eurpan.vcf\n";
}
if($ARGV[0] eq "-h"){
	&help;
}else{
	open(VCF,"$ARGV[0]") or die;
	my %snp_pos;
	while(<VCF>){
		chomp;
		next if(/^#/);
		my @it = split(/\t/,$_);
		$snp_pos{$it[0]}{$it[1]} = 1;
	}
	close(VCF);
	open(IN,"$ARGV[1]") or die;
	my $good_n = 0;	
	my $total = 0;
	while(<IN>){
		chomp;
		next if(/^#/);
		$total++; #count the total number of SNPs
		my @it = split(/\t/,$_);
		if(exists $snp_pos{$it[0]}{$it[1]}){
			$good_n++; #count the good number of SNPs
		}
	}
	close(IN);
	my $rate = $good_n/$total;
	print "$ARGV[1]\t$good_n\t$total\t$rate\n";
}
