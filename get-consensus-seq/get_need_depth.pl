use strict;
use warnings;
my (@sample,@it,%infor);
open(LIST,"$ARGV[0]") or die;
while(<LIST>){
	chomp;
	push @sample,$_;
}
close(LIST);
open(DP,"$ARGV[1]") or die;
while(<DP>){
	chomp;
	@it = split(/\s/,$_);
	$infor{$it[0]} = $_;
}
close(DP);

foreach my $i(@sample){
	print "$infor{$i}\n";
}
