#!/usr/bin/sh
idlist=$1
for ii in `cat $idlist`
do  
sample=$ii
perl seqphase1.pl -1 ./$sample.fas -p ./$sample
/data/data/Quercus/analysis/wo/134_phased/phase/PHASE -MR3 -S1477 -X1 -N100 -F0.01 -O0.01 -l8 -x1 -p0.9 -q0.9 ./$sample.inp ./$sample.out 10000 10 10000
perl seqphase2.pl -c ./$sample.const -i ./$sample.out -o ./phased_$sample.fas

done

