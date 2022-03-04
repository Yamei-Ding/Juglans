GridFile_dir=$1
FreqFile_dir=$2
Output=$3
mkdir -p $Output
for chr in `cat $4`
do
	SweepFinder2 -su $GridFile_dir/${chr}.grid.20k $FreqFile_dir/${chr}.fre $Output/${chr}.su.grid.20k.out 
done

