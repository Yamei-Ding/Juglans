for file in `cat $1`
do
	#nohup vcftools --vcf /data1/dingym_data/Juglans/Section_Dioscaryon/Map2download_Jre/analysis/2021-GONE/$2 --keep $file --recode --out 02.BQN.${file} &
	nohup vcftools --vcf 02.BQN.${file}.recode.vcf --maf 0.0000001 --recode --out 03.BQN.rmmono.${file} &
done
