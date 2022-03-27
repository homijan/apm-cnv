#!/bin/bash
# Directory for cnvkit computations
WRKDIR=$PWD
# Directory providing HEMESTAMP data
DATADIR="/drive3/dkurtz/HEMESTAMP"
# Loop over HEMESTAMP labels from HSTAMP0001 to HSTAMP0251 to prepare the list of BAM files 
BAMLIST=()
for i in {1..251}
do
  # Create dir and file variables according to the bam file name (need for different number of zeros)
  if [ $i -lt 10 ]
  then
    BAMDIR=${DATADIR}/HSTAMP000$i/demultiplexed/Sample_HSTAMP000${i}-T1_Tumor
    BAMFILE=Sample_HSTAMP000${i}-T1_Tumor.sorted.samtools-deduped.sorted
  else
    if [ $i -lt 100 ]
    then
      BAMDIR=${DATADIR}/HSTAMP00$i/demultiplexed/Sample_HSTAMP00${i}-T1_Tumor
      BAMFILE=Sample_HSTAMP00${i}-T1_Tumor.sorted.samtools-deduped.sorted
    else
      BAMDIR=${DATADIR}/HSTAMP0$i/demultiplexed/Sample_HSTAMP0${i}-T1_Tumor
      BAMFILE=Sample_HSTAMP0${i}-T1_Tumor.sorted.samtools-deduped.sorted
    fi
  fi
  BAMLIST+=("${BAMDIR}/${BAMFILE}.bam")
done
# Generate the `baits.target.bed` and `baits.antitarget.bed` files using `baits.bed` being provided
# baits.bed -> /drive3/cfDNA/selectors/Heme-STAMP_SEP2017.add500bp.bed
# Output: `baits.target.bed` and `baits.antitarget.bed`
cnvkit.py autobin ${BAMLIST[@]} -t ${WRKDIR}/baits.bed -g ${WRKDIR}/access.hg19.bed
