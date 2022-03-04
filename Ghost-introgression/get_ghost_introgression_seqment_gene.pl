use strict;
use warnings;
#Author: Ding, Ya-Mei
sub help{
	print "perl xxx.pl Jre.gff flt.segment\n";
}
if($ARGV[0] eq "-h"){
	&help;
}else{
	open(GFF,"$ARGV[0]") or die;
	my %gff;
	while(<GFF>){
		chomp;
		my @it = split(/\t/,$_);
		my $st_ed = "$it[2]\t$it[3]";
		$gff{$it[0]}{$it[1]} = $st_ed;
	}
	close(GFF);
	open(IN,"$ARGV[1]") or die;
	my %segment;
	while(<IN>){
		chomp;
		next if(/^CHROM/);
		my @it = split(/\t/,$_);
		push @{$segment{$it[0]}{$it[5]}},$it[1];
	}
	close(IN);
	my %segment_gene;
	foreach my $i(sort keys %segment){
		my %tmp_segment = %{$segment{$i}};
		foreach my $j(sort {$a<=>$b} keys %tmp_segment){
			my $segment_st = $tmp_segment{$j}[0];
			my $segment_ed = $tmp_segment{$j}[-1];
			foreach my $k(sort keys %{$gff{$i}}){
				my $gene_st;
				my $gene_ed;
				my @tmp = split(/\t/,$gff{$i}{$k});
				if($tmp[0] < $tmp[1]){
					$gene_st = $tmp[0];
					$gene_ed = $tmp[1];
				}else{
					$gene_st = $tmp[1];
					$gene_ed = $tmp[0];
				}
				if($gene_st <= $segment_st && $gene_ed >= $segment_ed ){
					push @{$segment_gene{$i}},$k;
				}elsif($gene_st >= $segment_st && $gene_st < $segment_ed && $gene_ed >= $segment_ed ){
					push @{$segment_gene{$i}},$k;
				}elsif($gene_st <= $segment_st && $gene_ed >$segment_st && $gene_ed <= $segment_ed){
					push @{$segment_gene{$i}},$k;
				}elsif($gene_st >= $segment_st && $gene_ed > $segment_st && $gene_ed <= $segment_ed){
					push @{$segment_gene{$i}},$k;
				}else{
					next;
				}

			}
		}
	}
	foreach my $i(sort keys %segment_gene){
		my @tmp_gene = @{$segment_gene{$i}};
		my %count;
		my @uniq = grep{++$count{$_} == 1}@tmp_gene;
		foreach my $j(@uniq){
			print "$i\t$j\n";
		}
	}
}
