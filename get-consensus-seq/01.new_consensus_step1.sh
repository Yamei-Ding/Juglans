refseq="/data1/dingym_data/Juglans/Section_Dioscaryon/Map2download_Jre/reference/JrSerr_genome_100k.fa"
consensusSeq="/data1/dingym_data/Juglans/Section_Dioscaryon/Map2download_Jre/analysis/2021-consensus/step1_consensus"
filtersnp="/data1/dingym_data/Juglans/Section_Dioscaryon/Map2download_Jre/samtoolscall/filter_snp"
deletesnp="/data1/dingym_data/Juglans/Section_Dioscaryon/Map2download_Jre/samtoolscall/delete_snp"
vcf="/data1/dingym_data/Juglans/Section_Dioscaryon/Map2download_Jre/samtoolscall"
script="/data1/dingym_data/Juglans/Section_Dioscaryon/Map2download_Jre/analysis/2021-consensus/consensus_scripts"
mkdir -p $filtersnp
mkdir -p $deletesnp
mkdir -p $consensusSeq

#accroding to the depth file filter the singlecall vcf file
FILENAME=$1
function While_read_LINE(){
        cat $FILENAME | while read LINE
        do
                str=$LINE
                var=($str)
                sample=${var[0]}
                depth=${var[1]}
#		min=${var[1]}
#		max=${var[2]}
		min=$(echo "$depth/3+0.5" |bc -l|cut -d. -f1)
		max=$(echo "$depth*2+0.5" |bc -l| cut -d. -f1)
		echo $sample $min $max
		#keeping snp mapping depth between 1/3*depth and 2*depth
		vcfutils.pl varFilter -p -d $min -D $max $vcf/$sample.samtools.vcf > $filtersnp/$sample.flt.vcf 2> $deletesnp/$sample.del.vcf
		perl $script/consensus_withDel.pl $refseq $filtersnp/$sample.flt.vcf $deletesnp/$sample.del.vcf $consensusSeq/$sample.fasta  #my ($fasta,$pos,$delfile,$out)=@ARGV;
#		gzip $sample.samtools.vcf
	done
}
While_read_LINE
