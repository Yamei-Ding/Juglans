for file in `cat $1`
do
	nohup perl count_SNP.pl /data1/dingym_data/Juglans/Section_Dioscaryon/Map2download_Jre/analysis/2022-check-ancestor/02.BQN.remove.mono.9ind.vcf.recode.vcf 03.BQN.rmmono.${file}.recode.vcf 1>./log/${file}.result 2>./log/${file}.err &
done
