#!/bin/bash
# Directory for cnvkit computations
WRKDIR=$PWD
# Directory providing HEMESTAMP data
DATADIR="/drive3/dkurtz/HEMESTAMP"
# Loop over HEMESTAMP labels. Tumor samples < 201 -> WRKDIR/results-cnn-tumor, Normal samples >=201 -> WRKDIR/results-cnn-normal
NORMALSTART=201
for i in {86..251}
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
  if [ $i -lt $NORMALSTART ]
  then
    OUTDIR="results-cnn-tumor"
  else
    OUTDIR="results-cnn-normal"
  fi
  # For each sample...
  cnvkit.py coverage ${BAMDIR}/${BAMFILE}.bam baits.target.bed -o ${WRKDIR}/${OUTDIR}/${BAMFILE}.targetcoverage.cnn
  cnvkit.py coverage ${BAMDIR}/${BAMFILE}.bam baits.antitarget.bed -o ${WRKDIR}/${OUTDIR}/${BAMFILE}.antitargetcoverage.cnn
done
