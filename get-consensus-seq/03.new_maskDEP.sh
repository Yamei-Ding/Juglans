#!/usr/bash
maskdepth="/data1/dingym_data/Juglans/Section_Dioscaryon/Map2download_Jre/analysis/2021-consensus/step2_consensus"
depth="/data1/dingym_data/Juglans/Section_Dioscaryon/Map2download_Jre/depth/depth"
un_mask="/data1/dingym_data/Juglans/Section_Dioscaryon/Map2download_Jre/analysis/2021-consensus/step1_consensus"
mkdir -p "$maskdepth"
FILENAME=$1
function While_read_LINE(){
        cat $FILENAME | while read LINE
        do
                str=$LINE
                var=($str)
                sample=${var[0]}
                dp=${var[1]}
		min=$(echo "$dp/3+0.5" |bc -l|cut -d. -f1)
		max=$(echo "$dp*2+0.5" |bc -l| cut -d. -f1)
		echo $sample $min $max
		perl test_maskDEP.pl ref_length.txt $un_mask/$sample.fasta $depth/$sample.depth.txt $min $max 1>$maskdepth/$sample.maskdep.fasta
	done
}
While_read_LINE
