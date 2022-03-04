
my $header=0;
my $loci="null";
my $keep=0;
my $i=0;
my @seqs;
my @names;
my $printout;
while(<>){
	next if (/^\n$/);
	chomp;
	if($header == 0 ){
		#print "$_\n";
		$header++;
		next;
	}
	if(/loci/){
		#$i=$i-1;
		#print STDERR "$i\n";
		&printloci($loci,$i) if($i > 0);
		$loci = "$_";
		$i=0;
		#$keep = 0;
		next;
	}
	my @s = split(/\s+/);
	$names[$i] = $s[0];
	$seqs[$i] = $s[1];
	$i++;
}
&printloci($loci,$i) if($i > 0);

print "$keep\n$printout";

sub printloci{
	my ($l,$n) = @_;
	$n = $n-1;
	my $k = 0;
	foreach my $ii (0 .. $n){
		foreach my $jj (0 .. $ii){
			$k++ if($seqs[$ii] ne $seqs[$jj]);
		}
	}
	if($k > 0){
		$printout .= "$l\n";
		foreach my $ii (0 .. $n){
			$printout .= "$names[$ii]  $seqs[$ii]\n";
		}
		$keep++;
	}
}

