for file in `cat $1`
do
	nohup sh 01.new_consensus_step1.sh $file &
done
