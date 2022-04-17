#!/bin/bash
# Directory for ichorCNA computations
WRKDIR=$PWD
# Directory providing HEMESTAMP data
DATADIR="/drive3/dkurtz/HEMESTAMP"
# Reference bed file for targeted regions from HEMESTAMP
REFBED="/drive3/cfDNA/selectors/Heme-STAMP_SEP2017.add500bp.bed"
#REFBED="/drive3/cfDNA/selectors/Heme-STAMP_SEP2017.bed"
# Loop over HEMESTAMP labels
NORMALSTART=201
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
  if [ $i -lt $NORMALSTART ]
  then
    OUTDIR="files-tumor"
  else
    OUTDIR="files-normal"
  fi
  if [ ! -f ${WRKDIR}/${OUTDIR}/${BAMFILE}.offtarget.bam ]; then
    # Run samtools to get offtarget bam file.
    echo "samtools view -b -L $REFBED -o ${WRKDIR}/${OUTDIR}/${BAMFILE}.ontarget.bam -U ${WRKDIR}/${OUTDIR}/${BAMFILE}.offtarget.bam ${BAMDIR}/${BAMFILE}.bam"
    samtools view -b -L $REFBED -o ${WRKDIR}/${OUTDIR}/${BAMFILE}.ontarget.bam -U ${WRKDIR}/${OUTDIR}/${BAMFILE}.offtarget.bam ${BAMDIR}/${BAMFILE}.bam
    # Run samtools to get bam index
    echo "samtools index ${WRKDIR}/${OUTDIR}/${BAMFILE}.offtarget.bam"
    samtools index ${WRKDIR}/${OUTDIR}/${BAMFILE}.offtarget.bam
  fi
done
