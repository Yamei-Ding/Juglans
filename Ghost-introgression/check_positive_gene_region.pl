use strict;
use warnings;
#Author: Ding, Ya-Mei
sub help{
	print "pelr xxx.pl gene.list sp.gff sprime.flt.txt\n";
}
if($ARGV[0] eq "-h"){
	&help;
}else{
	open(IN,"$ARGV[0]") or die;
	my @gene;
	while(<IN>){
		chomp;
		push @gene,$_;
	}
	close(IN);
	open(GFF,"$ARGV[1]") or die;
	my %gff;
	while(<GFF>){
		chomp;
		my @it = split(/\t/,$_);
		my $st_ed = "$it[2]\t$it[3]";
		$gff{$it[0]}{$it[1]} = $st_ed;
	}
	close(GFF);
	my %gene_st_ed;
	foreach my $i(sort keys %gff){
		foreach my $j(sort keys %{$gff{$i}}){
			if(grep{$_ eq $j}@gene){
				$gene_st_ed{$i}{$j} = $gff{$i}{$j};
			}
		}
	}
	open(IN,"$ARGV[2]") or die;
	my %segment;
	while(<IN>){
		chomp;
		next if(/^CH/);
		my @it = split(/\t/,$_);
		push @{$segment{$it[5]}{$it[0]}},$it[1];
	}
	close(IN);
	my %infor;
	foreach my $i(sort keys %segment){
		foreach my $j(sort keys %{$segment{$i}}){
			my @sort = sort {$a<=>$b}@{$segment{$i}{$j}};
			my $seg_st = $sort[0];
			my $seg_ed = $sort[-1];
			foreach my $k(sort keys %{$gene_st_ed{$j}}){
				my @gene_tmp = split(/\t/,$gene_st_ed{$j}{$k});
				my $gene_st = $gene_tmp[0];
				my $gene_ed = $gene_tmp[1];
				if($gene_st <= $seg_st && $gene_ed >= $seg_st && $gene_ed <= $seg_ed ){
					my $gene_length = $gene_ed - $gene_st +1;
					my $region_length = $gene_ed - $seg_st +1;
					my $rate = $region_length/$gene_length;
					$infor{$k} = "$region_length\t$gene_length\t$rate";
					#print "$region_length\t$gene_length\t$rate\n";
				}elsif($gene_st >= $seg_st && $gene_ed <= $seg_ed ){
					my $gene_length = $gene_ed - $gene_st +1;
					my $region_length = $gene_ed - $gene_st +1;
					my $rate = $region_length/$gene_length;
					$infor{$k} = "$region_length\t$gene_length\t$rate";
				#	print "$region_length\t$gene_length\t$rate\n";
				}elsif($gene_st >= $seg_st && $gene_st <= $seg_ed && $gene_ed >= $seg_ed ){
					my $gene_length = $gene_ed - $gene_st +1;
					my $region_length = $seg_ed - $gene_st +1;
					my $rate = $region_length/$gene_length;
					$infor{$k} = "$region_length\t$gene_length\t$rate";
					#print "$region_length\t$gene_length\t$rate\n";
				}else{
					next;
					#print "$k\t$gene_st_ed{$j}{$k}\tsegment$i\t$seg_st\t$seg_ed\n";
				}
			}	
		}
	}
	foreach my $i(sort keys %infor){
		print "$i\t$infor{$i}\n";
	}
}
