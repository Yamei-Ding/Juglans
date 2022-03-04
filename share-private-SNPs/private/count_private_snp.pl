use strict;
use warnings;
sub help{
	print "pelr xxx.pl mix.vcf eurpan.vcf\n";
}
sub read_vcf{
	my ($file1,$file2) = @_;
	open(IN,$file1) or die;
	my %snp_combine;
	while(<IN>){
		chomp;
		next if (/^#/);
		my @it = split(/\t/,$_);
		$snp_combine{$it[0]}{$it[1]} = 1;
	}
	close(IN);
	open(IN,$file2) or die;
	while(<IN>){
		chomp;
		next if(/^#/);
		my @it = split(/\t/,$_);
		if(!exists $snp_combine{$it[0]}{$it[1]}){
			$snp_combine{$it[0]}{$it[1]} = 1;
		}
	}
	close(IN);
	return %snp_combine;
}
if($ARGV[0] eq "-h"){
	&help;
}else{
	my (%combine) = &read_vcf($ARGV[0],$ARGV[1]);
	open(VCF,"$ARGV[2]") or die; #ref
	my %snp_pos;
	my $num_snp = 0;
	while(<VCF>){
		chomp;
		next if(/^#/);
		$num_snp++;
		my @it = split(/\t/,$_);
		$snp_pos{$it[0]}{$it[1]} = 1;
	}
	close(VCF);
	my $private = 0;
	foreach my $i(sort keys %snp_pos){
		foreach my $j(sort keys %{$snp_pos{$i}}){
			if(!exists $combine{$i}{$j}){
				$private++;
				#print "$combine{$i}{$j}\n";
				#next;
			}else{
				#$private++;
				next;
			}
		}
	}
	my $rate = $private/$num_snp;
	print "$ARGV[2]\t$private\t$num_snp\t$rate\n";
}
