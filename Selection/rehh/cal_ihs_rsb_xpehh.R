# !!!!before calculate iHS/Rsb/XP-EHH, concatenate chromosome-wise data frames to a data frame for the whole genome
library(rehh)
library(data.table)
library(vcfR)
library(ggplot2)

setwd("/data/data/Juglandaceae/Platycarya/10_selection/6_rehh/Jre")
# read scan file of two pops
#wgscan_Jsi <- read.table("test.scan.whole",header = T)
#wgscan_Jre <- read.table("test2.scan.whole",header = T)
wgscan_Jsi <- read.table("Jsi.scan.whole",header = T)
wgscan_Jre <- read.table("Jre.scan.whole",header = T)

# cal iHS/Rsb/XP-EHH
ihs_Jsi <- ihh2ihs(wgscan_Jsi,min_nhaplo = 10, freqbin = 1)
ihs_Jre <- ihh2ihs(wgscan_Jre,min_nhaplo = 10,freqbin = 1)
write.table(ihs_Jsi$ihs, file = "ihs_Jsi.txt", quote = F, col.name = T, row.names = F)
write.table(ihs_Jre$ihs, file = "ihs_Jre.txt", quote = F, col.name = T, row.names = F)

png("ihs_Jsi.png",width=1600,height=900,res=72)
manhattanplot(ihs_Jsi,
              main = "iHS (Jsi)")
dev.off()
png("ihs_Jsi_pvalue.png",width=1600,height=900,res=72)
manhattanplot(ihs_Jsi,
              pval = TRUE,
              threshold = 4,
              main = "p-value of iHS (Jsi)")
dev.off()

png("ihs_Jre.png",width=1600,height=900,res=72)
manhattanplot(ihs_Jre,
              main = "iHS (Jre)")
dev.off()
png("ihs_Jre_pvalue.png",width=1600,height=900,res=72)
manhattanplot(ihs_Jsi,
              pval = TRUE,
              threshold = 4,
              main = "p-value of iHS (Jre)")
dev.off()

##plot by ggplot
### plot the iHS statistics
#ggplot(ihs_Jsi$ihs, aes(POSITION, IHS)) + geom_point()
### plot the log P-value 
#ggplot(ihs_Jsi$ihs, aes(POSITION, LOGPVALUE)) + geom_point()


xpehh <- ies2xpehh(scan_pop1 = wgscan_Jsi, scan_pop2 = wgscan_Jre, popname1 = "Jsi", popname2 = "Jre",min_nhaplo = 10,include_freq = T)
write.table(xpehh, file = "xpehh_Jsi-Jre.txt", quote = F, col.name = T, row.names = F)
png("xpehh_Jsi-Jre.png",width=1600,height=900,res=72)
manhattanplot(xpehh,
              main = "XP-EHH (Jsi-Jre)")
dev.off()
#JsiOT the xpEHH values
#ggplot(xpehh, aes(POSITION, XPEHH_Jsi_Jre)) + geom_point()

rsb <- ines2rsb(scan_pop1 = wgscan_Jsi, scan_pop2 = wgscan_Jre, popname1 = "Jsi", popname2 = "Jre",min_nhaplo = 10,include_freq = T)
write.table(rsb, file = "rsb_Jsi-Jre.txt", quote = F, col.name = T, row.names = F)
png("Rsb_Jsi-Jre.png",width=1600,height=900,res=72)
manhattanplot(rsb,
              main = "Rsb (Jsi-Jre)")
dev.off()
