#!/bin/bash
# Directory for cnvkit computations
WRKDIR=$PWD
echo "Working in $WRKDIR"
# Make sure to use this environment `conda activate cnvkit`
# Generate the reference hg19 genome bed file using `hg19.fa` being provided
# hg19.fa -> /data/indexes/hg19.fa
ln -s /data/indexes/hg19.fa hg19.fa
# Output: `access.hg19.bed`
cnvkit.py access ${WRKDIR}/hg19.fa -o ${WRKDIR}/access.hg19.bed
# Generate the target and antitarget.baits bed file using the `baits.bed` and all the samples
# baits.bed -> /drive3/cfDNA/selectors/Heme-STAMP_SEP2017.add500bp.bed
ln -s /drive3/cfDNA/selectors/Heme-STAMP_SEP2017.add500bp.bed baits.bed
# Output: `baits.target.bed` and `baits.antitarget.bed`
./generate-beds.sh
# Generate cnn files from all the samples 
# Tumor samples < 201 -> WRKDIR/results-cnn-tumor, Normal samples >=201 -> WRKDIR/results-cnn-normal
mkdir results-cnn-tumor 
mkdir results-cnn-normal
./generate-cnn.sh
# Generate a pooled normal references from all normal samples called `my_reference.cnn`
cnvkit.py reference ${WRKDIR}/results-cnn-normal/*.{,anti}targetcoverage.cnn --fasta ${WRKDIR}/hg19.fa -o ${WRKDIR}/my_reference.cnn
# Loop over the tumor.cnn samples
for i in ${WRKDIR}/results-cnn-tumor/*.antitargetcoverage.cnn
do
  # Trim the string to get a root name of the sample
  SAMPLE="$(echo $i | sed 's/.antitargetcoverage.cnn//g')"
  echo "Working on sample: $SAMPLE"
  # For each tumor sample...
  cnvkit.py fix ${SAMPLE}.targetcoverage.cnn ${SAMPLE}.antitargetcoverage.cnn my_reference.cnn -o ${SAMPLE}.cnr
  cnvkit.py segment ${SAMPLE}.cnr -o ${SAMPLE}.cns
  # Optionally, with --scatter and --diagram
  cnvkit.py scatter ${SAMPLE}.cnr -s ${SAMPLE}.cns -o ${SAMPLE}-scatter.pdf
  cnvkit.py diagram ${SAMPLE}.cnr -s ${SAMPLE}.cns -o ${SAMPLE}-diagram.pdf
done
