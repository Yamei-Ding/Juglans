for random in `cat $1`
do
	perl count_private_snp.pl 03.BQN.rmmono.China_${random}.list.recode.vcf 03.BQN.rmmono.Europe_${random}.list.recode.vcf ../02.BQN.remove.mono.9ind.vcf.recode.vcf 1>9mix.${random}.private.log  2>error	
	perl count_private_snp.pl 03.BQN.rmmono.Europe_${random}.list.recode.vcf ../02.BQN.remove.mono.9ind.vcf.recode.vcf 03.BQN.rmmono.China_${random}.list.recode.vcf 1>China.${random}.private.log  2>error
	perl count_private_snp.pl 03.BQN.rmmono.China_${random}.list.recode.vcf ../02.BQN.remove.mono.9ind.vcf.recode.vcf 03.BQN.rmmono.Europe_${random}.list.recode.vcf 1>Europe.${random}.private.log  2>error
done
