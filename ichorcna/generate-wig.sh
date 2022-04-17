#!/bin/bash
# Need to do `conda activate hmmcopy` before launching this script
# Directory for hmmcopy computations
WRKDIR=$PWD
# Loop over offtarget bam files in files-tumor and files-normal directories.
for bamfile in ${WRKDIR}/files-*/*.offtarget.bam
do
  if [ ! -f ${bamfile}.wig ]; then
    # Run hmmcopy to get offtarget wig file.
    echo "readCounter --window 1000000 --quality 20 --chromosome 'chr1,chr2,chr3,chr4,chr5,chr6,chr7,chr8,chr9,chr10,chr11,chr12,chr13,chr14,chr15,chr16,chr17,chr18,chr19,chr20,chr21,chr22,chrX,chrY' ${bamfile} > ${bamfile}.wig" 
    readCounter --window 1000000 --quality 20 --chromosome "chr1,chr2,chr3,chr4,chr5,chr6,chr7,chr8,chr9,chr10,chr11,chr12,chr13,chr14,chr15,chr16,chr17,chr18,chr19,chr20,chr21,chr22,chrX,chrY" ${bamfile} > ${bamfile}.wig
  fi
done
