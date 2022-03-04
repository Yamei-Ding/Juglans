mkdir -p ../step3_maskCDS
for id in `cat $1`
do
	mkdir -p ../step3_maskCDS/20k
	mkdir -p ../step3_maskCDS/50k
	perl flt_cosensus_cds.pl ref_length.txt ../step2_consensus/consensus/$id.maskdep.fasta JrSerr_gene.gff  ../step3_maskCDS/20k/${id}.maskCDS.fasta 20000 
	perl flt_cosensus_cds.pl ref_length.txt ../step2_consensus/consensus/$id.maskdep.fasta JrSerr_gene.gff  ../step3_maskCDS/50k/${id}.maskCDS.fasta 50000 
done
