#get sweepfinder Allele frequency file
perl vcf2sweepfinder.pl /data1/dingym_data/Juglans/Section_Dioscaryon/Map2download_Jre/analysis/2021-GONE/2pop/Jre.vcf Jre
perl vcf2sweepfinder.pl /data1/dingym_data/Juglans/Section_Dioscaryon/Map2download_Jre/analysis/2021-GONE/2pop/Jsi.vcf Jsi
## get CombinedFreqFile, combine 17 chr information
sh cat_frq.sh chr.list Jsi ../Jsi/Allele_frequency_file
sh cat_frq.sh chr.list Jre ../Jre/Allele_frequency_file
sh cat_frq.sh chr.list Jsi ../Jsi/new_Allele_frequency_file/
sh cat_frq.sh chr.list Jsi ../Jsi/new_Allele_frequency_file/
## get recombination rate for each SNPs site
cd /data/data/Juglandaceae/Platycarya/6_PopGenomicAnaly/15_recombination/Jre
perl /data/data/Juglandaceae/Platycarya/6_PopGenomicAnaly/15_recombination/Jre/test.pl /data/data/Juglandaceae/Platycarya/6_PopGenomicAnaly/15_recombination/Jre/blocklist_500k_Jre_nonull.sort  1_Jre_block_500k_res 8000 Jre_recombination.map
perl /data/data/Juglandaceae/Platycarya/6_PopGenomicAnaly/15_recombination/Jre/test.pl /data/data/Juglandaceae/Platycarya/6_PopGenomicAnaly/15_recombination/Jre/blocklist_500k_Jre_nonull.sort  2_Jsi_block_500k_res 8000 Jsi_recombination.map
##get each chromosome recombination rate file and grid file
perl get_each_chr_recombination_rate.pl Jre_recombination.map Jre ../Jre/Recombination_file/ ../Jre/Grid_file
perl get_each_chr_recombination_rate.pl Jsi_recombination.map Jsi ../Jsi/Recombination_file/ ../Jsi/Grid_file
##get 20k windows grid
perl get_grid_file_from_TajimaD.pl /data/data/Juglandaceae/Platycarya/6_PopGenomicAnaly/5_vcftools/Jre/Jre.Tajima.D Jre ../Jre/Grid_file_20k
perl get_grid_file_from_TajimaD.pl /data/data/Juglandaceae/Platycarya/6_PopGenomicAnaly/5_vcftools/Jre/Jsi.Tajima.D Jsi ../Jsi/Grid_file_20k
##get 20k mid grid, please motify the line 25 to windows length/2
perl get_mid_grid_file_from_TajimaD.pl /data/data/Juglandaceae/Platycarya/6_PopGenomicAnaly/5_vcftools/Jre/Jsi.Tajima.D Jsi ../Jsi/Grid_file_mid_20k
perl get_mid_grid_file_from_TajimaD.pl /data/data/Juglandaceae/Platycarya/6_PopGenomicAnaly/5_vcftools/Jre/Jre.Tajima.D Jre ../Jre/Grid_file_mid_20k
## use sweepfinder get SpectFile file
SweepFinder2 -f Jsi-17chr.fre Jsi-17chr.spect
SweepFinder2 -f Jre-17chr.fre Jre-17chr.spect
SweepFinder2 -f Jre-new-17chr.fre Jre-new-17chr.spect
SweepFinder2 -f Jsi-new-17chr.fre Jsi-new-17chr.spect
## Scan for selective sweeps
sh 01.scan_selectivw_sweep.sh ../Jsi/Grid_file_20k/ ../Jsi/Allele_frequency_file/ ../Jsi/su.grid.20k.out ../Jsi/Jsi.list  &>01.log
sh 01.scan_selectivw_sweep.sh  ../Jre/Grid_file_20k/ ../Jre/Allele_frequency_file/ ../Jre/su.grid.20k.out ../Jre/Jre.list  &>01_Jre.log
## Scan for selective sweeps with pre-computed empirical spectrum
sh 02.scan_empirical_spectrum.sh ../Jsi/Grid_file_20k/ ../Jsi/Allele_frequency_file/ Jsi-17chr.spect ../Jsi/02.lu.grid.20k.out ../Jsi/Jsi.list &>02_Jsi.log
sh 02.scan_empirical_spectrum.sh ../Jsi/Grid_file_20k/ ../Jsi/Allele_frequency_file/ Jsi-17chr.spect ../Jre/02.lu.grid.20k.out ../Jsi/Jre.list &>02_Jre.log
## 
sh 02.scan_empirical_spectrum.sh ../Jsi/Grid_file_mid_20k/ ../Jsi/Allele_frequency_file/ Jsi-17chr.spect ../Jsi/02.lu.grid.mid.20k.out ../Jsi/Jsi.list &>02_Jsi_mid_20k.log &
sh 02.scan_empirical_spectrum.sh ../Jre/Grid_file_mid_20k/ ../Jre/Allele_frequency_file/ Jre-17chr.spect ../Jre/02.lu.grid.mid.20k.out ../Jre/Jre.list &>02_Jre_mid_20k.log &
## Scan for selective sweeps with pre-computed empirical spectrum and recombination map
####when some snp was not in recombination file, sweepfinder was error
perl prepare_new_allele_frequence.pl ../Jre/Recombination_file/ ../Jre/Allele_frequency_file/ ../Jre/new_Allele_frequency_file/
perl prepare_new_allele_frequence.pl ../Jsi/Recombination_file/ ../Jsi/Allele_frequency_file/ ../Jsi/new_Allele_frequency_file/ 
sh 03.scan_spectrum_recombination.sh ../Jsi/Grid_file_mid_20k/ ../Jsi/new_Allele_frequency_file/ Jsi-17chr.spect ../Jsi/Recombination_file/ ../Jsi/03.lru.grid.mid.20k.out/ ../Jsi/Jsi.list &>03_Jsi.log
sh 03.scan_spectrum_recombination.sh ../Jre/Grid_file_mid_20k/ ../Jre/new_Allele_frequency_file/ Jre-17chr.spect ../Jre/Recombination_file/ ../Jre/03.lru.grid.mid.20k.out/ ../Jre/Jre.list &>03_Jre.log
