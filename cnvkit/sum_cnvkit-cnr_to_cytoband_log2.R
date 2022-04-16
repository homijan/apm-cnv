#!/usr/bin/env Rscript

library(dplyr)
library(data.table)

#print(sessionInfo())

args = commandArgs(trailingOnly=TRUE)

# args[1]=#Temp2 file
# args[2]=#Outputfile

# Read new merged list
data <- read.delim(args[1], header=FALSE)
dat=as.data.frame(data, sep="\t", header=F, stringsAsFactors=FALSE)

colnames(dat) <- c("chr_1","start_1","end_1","cytoband","chr_2","start_2","end_2","gene","log2","depth","weight", "length")

# Extract log2 for each cytoband of each chromosome. Use median(log2) of the cytoband log2 data. 
dat <- dat %>% group_by(chr_1, cytoband) %>% summarise(median(log2), n=n())

# Write out the log2 chromosome-cytoband data
fwrite(dat, file = args[2] ,row.names=F, na="NA", col.names=T, quote=F, sep="\t")

