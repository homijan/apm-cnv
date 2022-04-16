#!/bin/bash
# Directory for cnvkit computations
WRKDIR=$PWD
# Directory providing HEMESTAMP data
DATADIR="/drive3/dkurtz/HEMESTAMP"
# Loop over HEMESTAMP labels from HSTAMP0001 to HSTAMP0251 to prepare the list of BAM files
# Note that barcode and samtools files are used to generate two versions of `baits.target.bed` and `baits.antitarget.bed`
SAMTOOLSBAMLIST=()
for i in {1..251}
do
  # Create dir and file variables according to the bam file name (need for different number of zeros)
  if [ $i -lt 10 ]
  then
    SAMTOOLSBAMDIR=${DATADIR}/HSTAMP000$i/demultiplexed/Sample_HSTAMP000${i}-T1_Tumor
    BAMFILE=Sample_HSTAMP000${i}-T1_Tumor
  else
    if [ $i -lt 100 ]
    then
      SAMTOOLSBAMDIR=${DATADIR}/HSTAMP00$i/demultiplexed/Sample_HSTAMP00${i}-T1_Tumor
      BAMFILE=Sample_HSTAMP00${i}-T1_Tumor
    else
      SAMTOOLSBAMDIR=${DATADIR}/HSTAMP0$i/demultiplexed/Sample_HSTAMP0${i}-T1_Tumor
      BAMFILE=Sample_HSTAMP0${i}-T1_Tumor
    fi
  fi
  SAMTOOLSBAMLIST+=("${SAMTOOLSBAMDIR}/${BAMFILE}.sorted.samtools-deduped.sorted.bam")
done
# Generate the `baits.target.bed` and `baits.antitarget.bed` files using `baits.bed` being provided
# baits.bed -> /drive3/cfDNA/selectors/Heme-STAMP_SEP2017.add500bp.bed
# Output: `baits.target.bed` and `baits.antitarget.bed`
cnvkit.py autobin ${SAMTOOLSBAMLIST[@]} -t ${WRKDIR}/baits.bed -g ${WRKDIR}/access.hg19.bed
# Tag the outputs with samtools
mv baits.target.bed ${WRKDIR}/baits.samtools.target.bed
mv baits.antitarget.bed ${WRKDIR}/baits.samtools.antitarget.bed
