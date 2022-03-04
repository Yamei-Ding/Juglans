for id in `cat $1`
do
	echo "nohup sh run.sh $id &"
done
