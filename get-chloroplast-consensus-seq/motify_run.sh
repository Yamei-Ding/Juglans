ref="/data/data/Juglandaceae/Section_Dioscaryon/cp_reference/Juglans_regia.fasta.txt"
depthdir="/data1/dingym_data/Juglans/Section_Dioscaryon/chloroplat_analysis/Map2Jre/depth"
vcfdir="/data1/dingym_data/Juglans/Section_Dioscaryon/chloroplat_analysis/Map2Jre/samtools_vcf"
#idlist=$1
#for i in `cat $idlist`
FILENAME=$1
function While_read_LINE(){
        cat $FILENAME | while read LINE
        do
                str=$LINE
                var=($str)
#                var=${var//\s/}
                sample=${var[0]}
                depth=${var[1]}
		echo "$sample"
#do
prefix=$sample
mkdir -p ./flt_vcfs #out put for keep
mkdir -p ./del_vcfs #out put for delete
vcfutils.pl varFilter -d $depth -p $vcfdir/$prefix.samtools.vcf >./flt_vcfs/$prefix.flt.vcf 2>./del_vcfs/$prefix.del.vcf  #flt_vcf output the variation site infor del_vcf output the variation site infor but the depth below 500
echo $i
mkdir -p fasta_cp
mkdir -p var_cp
perl bowen.pl $ref ./flt_vcfs/$prefix.flt.vcf ./del_vcfs/$prefix.del.vcf $prefix $depth >./fasta_cp/$prefix.dep.fasta 2>./var_cp/$prefix.log  #variation site become N or alt or ref
perl missing_data.pl ./fasta_cp/$prefix.dep.fasta $depthdir/$prefix.depth.txt $depth $prefix #depth below 500 become N
	done
}
While_read_LINE
