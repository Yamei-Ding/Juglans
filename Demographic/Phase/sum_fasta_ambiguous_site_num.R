list <- read.table("../880_fasta.list",header = F,stringsAsFactors = F)
result <- data.frame(gene="a",num=0,stringsAsFactors = F)
common <- c("A","T","G","C","N")
for(i in 1:nrow(list)){
  data <- read.table(list[i,1],stringsAsFactors = F)
  result[i,"gene"] <- list[i,1]
  result[i,"num"] <- 0
  for(j in 1:nchar(data[2,1])){
    tempsite <- "A"
    for(k in 1:(nrow(data)/2)){
      tempsite[k] <- substr(data[2*k,1],j,j)
    }
#    if(length(which(!(unique(tempsite)%in%common)))!=0)print(j)
    result[i,"num"] <- result[i,"num"]+length(which(!(unique(tempsite)%in%common)))
  }
}
write.table(result,"sumdeg_result.txt",col.names = F,row.names = F,quote = F)
