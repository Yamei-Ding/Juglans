GridFile_dir=$1
FreqFile_dir=$2
SpectFile=$3
Output=$4
mkdir -p $Output
for chr in `cat $5`
do
	nohup SweepFinder2 -lu $GridFile_dir/${chr}.grid.20k $FreqFile_dir/${chr}.fre $SpectFile $Output/${chr}.lu.grid.20k.out &
done

