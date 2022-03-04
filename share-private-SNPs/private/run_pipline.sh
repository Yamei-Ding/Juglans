##randome select individual
/usr/bin/perl random_select_ind_in_array.pl ../pure_0.8_result/Jre-C1.list Europe
##get vcf
sh multi_get_vcf.sh Europe.all.file 02.BQN.Jre-C1.31ind.recode.vcf &>ep.log
sh multi_get_vcf.sh Europe.all.file 02.BQN.Jre-C2.25ind.recode.vcf &>ch.log
sh multi_get_vcf.sh Jsi.all.file 02.BQN.Jsi.15ind.recode.vcf &>js.log
##check number of SNP in mix population
sh multi_count_SNP_in_Mix_pop.sh Europe.all.file 
##check private SNPs rate 
perl count_private_snp.pl ../02.BQN.remove.mono.9ind.vcf.recode.vcf ../02.BQN.remove.mono.eurpoean.vcf.recode.vcf 
sh multi_count_private_SNP.sh random.list 
perl get_share_SNP_number.pl ./
 perl get_private_SNP_rate.pl ./ 1>private.final.result
