use strict;
use warnings;
use List::Util qw(shuffle);
sub help{
	print "perl xxx.pl pop1.list popname  \n";
}
if($ARGV[0] eq "-h"){
	&help;
}else{
	for(my $i=1;$i<=20;$i++){
		open(IN,$ARGV[0]) or die;
		open(OUT,">>$ARGV[1]_random$i.list") or die;
		my @all_ind;
		while(<IN>){
			chomp;
			push @all_ind,$_;
		}
		close(IN);
		my @rand_data = shuffle(@all_ind);
		my @rand_select_data = @rand_data[0..8]; #random select 9 ind
		map {print OUT "$_\n"}@rand_select_data;
		close(OUT);
	}
}
