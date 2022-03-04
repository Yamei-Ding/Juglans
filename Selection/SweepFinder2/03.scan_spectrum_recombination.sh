GridFile_dir=$1
FreqFile_dir=$2
SpectFile=$3
RecFile=$4
Output=$5
mkdir -p $Output
for chr in `cat $6`
do
	echo "process $chr"
	nohup SweepFinder2 -lru $GridFile_dir/${chr}.grid.20k $FreqFile_dir/${chr}.fre $SpectFile $RecFile/${chr}.rec $Output/${chr}.lru.grid.20k.out &
done

