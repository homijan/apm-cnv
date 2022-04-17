#!/usr/bin/env Rscript

library(dplyr)
library(data.table)

#print(sessionInfo())

args = commandArgs(trailingOnly=TRUE)

# args[1]=#Temp3 file
# args[2]=#Outputfile

# Read new merged list
data <- read.delim(args[1], header=FALSE)
dat=as.data.frame(data, sep="\t", header=F, stringsAsFactors=FALSE)

colnames(dat) <- c("chr_1","start_1","end_1","cytoband","chr_2","start_2","end_2","log2","length")

dat <- dat %>% group_by(chr_1, cytoband) %>% summarise(median(log2), n=n())

fwrite(dat, file = args[2] ,row.names=F, na="NA", col.names=T, quote=F, sep="\t")

