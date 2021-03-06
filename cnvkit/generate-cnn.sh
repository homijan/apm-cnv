#!/bin/bash
# Directory for cnvkit computations
WRKDIR=$PWD
# Directory providing HEMESTAMP data
DATADIR="/drive3/dkurtz/HEMESTAMP"
# Loop over HEMESTAMP labels. Tumor samples < 201 -> WRKDIR/results-cnn-tumor, Normal samples >=201 -> WRKDIR/results-cnn-normal
NORMALSTART=201
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
  if [ $i -lt $NORMALSTART ]
  then
    OUTDIR="results-cnn-tumor"
  else
    OUTDIR="results-cnn-normal"
  fi
  # For each sample...
  # Use samtools-deduped bams
  if [ ! -f ${WRKDIR}/${OUTDIR}/${BAMFILE}.samtools.targetcoverage.cnn ]; then
    cnvkit.py coverage ${SAMTOOLSBAMDIR}/${BAMFILE}.sorted.samtools-deduped.sorted.bam ${WRKDIR}/baits.samtools.target.bed -o ${WRKDIR}/${OUTDIR}/${BAMFILE}.samtools.targetcoverage.cnn
  fi
  if [ ! -f ${WRKDIR}/${OUTDIR}/${BAMFILE}.samtools.antitargetcoverage.cnn ]; then
    # Always use samtools-deduped off-target bams
    cnvkit.py coverage ${SAMTOOLSBAMDIR}/${BAMFILE}.sorted.samtools-deduped.sorted.bam ${WRKDIR}/baits.samtools.antitarget.bed -o ${WRKDIR}/${OUTDIR}/${BAMFILE}.samtools.antitargetcoverage.cnn
  fi
done
