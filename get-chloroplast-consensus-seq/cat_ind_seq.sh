for ind in `cat $1`
do
	re="$re$2/$ind.flt.fasta "
done
cat $re 1>all.ind.fa
