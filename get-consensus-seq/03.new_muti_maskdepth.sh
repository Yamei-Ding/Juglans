for file in `cat $1`
do
	nohup sh 03.new_maskDEP.sh $file &
done
