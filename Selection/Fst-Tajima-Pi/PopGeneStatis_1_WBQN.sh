win=20000

nohup vcftools --vcf 02.BQN.Juglans_113ind.vcf --recode --recode-INFO-all --stdout  --keep list_Jre_65inds >Jre.vcf 2>log_Jre &
nohup vcftools --vcf 02.BQN.Juglans_113ind.vcf --recode --recode-INFO-all --stdout  --keep list_Jsi_16inds >Jsi.vcf 2>log_Jsi &
#:<<!
#pi 
nohup vcftools --vcf 02.BQN.Juglans_113ind.vcf --keep list_Jre_65inds --site-pi --out Jre 2>log_site_pi_Jre &
nohup vcftools --vcf 02.BQN.Juglans_113ind.vcf --keep list_Jsi_16inds --site-pi --out Jsi 2>log_site_pi_Jsi &
nohup vcftools --vcf 02.BQN.Juglans_113ind.vcf --keep list_Jre_65inds --window-pi 20000 --out Jre 2>log_pi_Jre &
nohup vcftools --vcf 02.BQN.Juglans_113ind.vcf --keep list_Jsi_16inds --window-pi 20000 --out Jsi 2>log_pi_Jsi &
#!

#:<<!
#FST
nohup vcftools --vcf 02.BQN.Juglans_113ind.vcf --weir-fst-pop list_Jre_65inds --weir-fst-pop list_Jsi_16inds --fst-window-size 20000 --out Jre-Jsi 2>log_fst_Jre-Jsi &
#!

#:<<!
#TajimaD
nohup vcftools --vcf 02.BQN.Juglans_113ind.vcf --keep list_Jre_65inds --TajimaD 20000 --out Jre 2>log_tajimaD_Jre &
nohup vcftools --vcf 02.BQN.Juglans_113ind.vcf --keep list_Jsi_16inds --TajimaD 20000 --out Jsi 2>log_tajimaD_Jsi &
#!

