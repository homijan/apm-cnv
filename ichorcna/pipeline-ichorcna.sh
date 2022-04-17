#!/bin/bash
# Run `./pipeline-ichorcna.sh < /dev/null &`
# Make sure to run 
# 1) `generate-offtarget-index.sh`
# 2) conda activate hmmcopy and then run `generate-wig.sh`
# 3) conda activate cnvkit
# Directory for ichorcna computations
WRKDIR=$PWD
# ichorCNA directory
ICHORDIR="/drive3/aliciapm/ichorCNA"
mkdir ${WRKDIR}/files-tumor
mkdir ${WRKDIR}/files-normal
./generate-offtarget-index.sh
# Activate the hmmcopy environment (give it 1 minute to be activated)
conda activate hmmcopy && sleep 1m
./generate-wig.sh
./generate-normal-reference.sh
# Loop over offtarget bam files of the tumor samples.
mkdir ${WRKDIR}/results-ichorcna
# Activate the cnvkit environment (give it 1 minute to be activated)
conda activate cnvkit && sleep 1m
for wigfile in ${WRKDIR}/files-tumor/*.offtarget.bam.wig
do
  # Weird trimming using sed to extract the hemestamp label
  TESTID="$(echo ${wigfile} | sed 's/.*Sample_//g' | sed 's/-T1_Tumor.*//g')"
  if [ ! -d ${WRKDIR}/results-ichorcna/${TESTID} ]; then
    # Run ichorcna to get final CNA results.
    Rscript ${ICHORDIR}/scripts/runIchorCNA.R --id $TESTID --WIG $i --normal "c(0.5,0.6,0.7,0.8,0.9)" --maxCN 5 --gcWig   ${ICHORDIR}/inst/extdata/gc_hg19_1000kb.wig --mapWig ${ICHORDIR}/inst/extdata/map_hg19_1000kb.wig --centromere ${ICHORDIR}/inst/extdata/GRCh37.p13_centromere_UCSC-gapTable.txt --normalPanel ${WRKDIR}/reference-normal_median.rds --includeHOMD False --chrs "c(1:22, \"X\")" --chrTrain "c(1:22)" --estimateNormal true --estimatePloidy True --scStates "c(1,3)" --txnStrength 1000 --outDir ${WRKDIR}/results-ichorcna
  fi
done

# Loop over offtarget bam files of the normal samples.
mkdir ${WRKDIR}/results-ichorcna-normals
for wigfile in ${WRKDIR}/files-normal/*.offtarget.bam.wig
do
  # Weird trimming using sed to extract the hemestamp label
  TESTID="$(echo ${wigfile} | sed 's/.*Sample_//g' | sed 's/-T1_Tumor.*//g')"
  if [ ! -d ${WRKDIR}/results-ichorcna/${TESTID} ]; then
    # Run ichorcna to get final CNA results.
    Rscript ${ICHORDIR}/scripts/runIchorCNA.R --id $TESTID --WIG $i --normal "c(0.5,0.6,0.7,0.8,0.9)" --maxCN 5 --gcWig   ${ICHORDIR}/inst/extdata/gc_hg19_1000kb.wig --mapWig ${ICHORDIR}/inst/extdata/map_hg19_1000kb.wig --centromere ${ICHORDIR}/inst/extdata/GRCh37.p13_centromere_UCSC-gapTable.txt --normalPanel ${WRKDIR}/reference-normal_median.rds --includeHOMD False --chrs "c(1:22, \"X\")" --chrTrain "c(1:22)" --estimateNormal true --estimatePloidy True --scStates "c(1,3)" --txnStrength 1000 --outDir ${WRKDIR}/results-ichorcna-normals
  fi
done