use strict;
use warnings;
use List::Util qw(shuffle);
sub help{
	print "perl xxx.pl pop1.list \n";
}
if($ARGV[0] eq "-h"){
	&help;
}else{
	open(IN,$ARGV[0]) or die;
	my @all_ind;
	while(<IN>){
		chomp;
		push @all_ind,$_;
	}
	close(IN);
	my @rand_data = shuffle(@all_ind);
	my @rand_select_data = @rand_data[0..9];
	map {print "$_\n"}@rand_select_data;
}
