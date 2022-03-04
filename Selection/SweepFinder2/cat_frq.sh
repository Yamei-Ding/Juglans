input=$3 #17 chr frq dir
for chr in `cat $1` #chr list 
do
	re="$re$input/$2-$chr.fre " #$2 prefix
done
	cat $re >$2-new-17chr.fre
