my ($vcfs,$idmap)=@ARGV;
open MAP,$idmap|| die;
#Date:2019.03.14
#Author: zhangbw Linan xull*
my @ids;
my @idtaxa;
while(<MAP>){
	chomp;
	my @it=split(/\s+/);
	print STDERR "$it[0],$it[1]\n";
	push @ids,$it[0];
	push @idtaxa,$it[1];
}
close MAP;

my $ntax=0;
my $nchar=0;
my %snps;
open VCF,$vcfs || die;
my $nline=0;
my @headers;
while(<VCF>){
	chomp;
	$nline++;
	if(/^#CHROM/){
		@headers= split(/\t/);
		foreach my $hid (9 .. $#headers){
			print STDERR "check id: $headers[$hid]\n";
			$ntax++;
		}
		next;
	}
	next if (/^#/);
	my @it = split(/\t/);
	$nchar++;
	foreach my $i (9 .. $#it){
		my $gt="?";
		if($it[$i] =~ /^0\/0\:/){
			$gt="0 0";
		}elsif($it[$i] =~ /^0\/1\:/){
			$gt="0 1";
		}elsif($it[$i] =~ /^1\/1\:/){
			$gt="1 1";
		}else{
			$gt="-9 -9";
			print STDERR "unknown gt at $nline\n";
		}
		#print STDERR "counting for $headers[$i]\n";
		$snps{$headers[$i]} .= " $gt";
		
	}	

}

foreach my $n ( 0 .. $#ids){
	my $k = $ids[$n];
	my $v = $snps{$k};
	#my ($sp,$taxa) = split(/\-/,$idtaxa[$n]);
	print STDERR "$k\t$sp\t$taxa\n";
	print "$k $idtaxa[$n]"."$v\n";
}




