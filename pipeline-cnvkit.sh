#!/bin/bash
# Directory for cnvkit computations
WRKDIR=$PWD
echo "Working in $WRKDIR"
# Make sure to use this environment `conda activate cnvkit`
# Generate the reference hg19 genome bed file using `hg19.fa` being provided
# hg19.fa -> /data/indexes/hg19.fa
ln -s /data/indexes/hg19.fa hg19.fa
# Output: `access.hg19.bed`
cnvkit.py access ${WRKDIR}/hg19.fa -o ${WRKDIR}/access.hg19.bed | tee access.out
# Generate the target and antitarget.baits bed file using the `baits.bed` and all the samples
# baits.bed -> /drive3/cfDNA/selectors/Heme-STAMP_SEP2017.add500bp.bed
ln -s /drive3/cfDNA/selectors/Heme-STAMP_SEP2017.add500bp.bed baits.bed
# Output: `baits.target.bed` and `baits.antitarget.bed`
./generate-beds.sh | tee generate-beds.out
# Generate cnn files from all the samples 
# Tumor samples < 201 -> WRKDIR/results-cnn-tumor, Normal samples >=201 -> WRKDIR/results-cnn-normal
mkdir results-cnn-tumor 
mkdir results-cnn-normal
./generate-cnn.sh | tee generate-cnn.out
# Generate a pooled normal references from all normal samples. Prepare two sets for comparison
# First use both samtools target and antitarget for `my_reference.samtools.cnn` 
# *.samtools.antitargetcoverage.cnn + *.samtools.targetcoverage.cnn
cnvkit.py reference ${WRKDIR}/results-cnn-normal/*.samtools.{coverage,antitargetcoverage}.cnn --fasta ${WRKDIR}/hg19.fa -o ${WRKDIR}/my_reference.samtools.cnn
# Second use barcode target and samtools antitarget for `my_reference.barcode.cnn`
# *.samtools.antitargetcoverage.cnn + *.barcode.targetcoverage.cnn
cnvkit.py reference ${WRKDIR}/results-cnn-normal/*.{barcode.targetcoverage,samtools.antitargetcoverage}.cnn --fasta ${WRKDIR}/hg19.fa -o ${WRKDIR}/my_reference.barcode.cnn
# Loop over the tumor.cnn samples
for i in ${WRKDIR}/results-cnn-tumor/*.samtools.antitargetcoverage.cnn
do
  # Trim the string to get a root name of the sample
  SAMPLE="$(echo $i | sed 's/.samtools.antitargetcoverage.cnn//g')"
  echo "Working on sample: $SAMPLE"
  ## First using samtools-deduped on-target data
  # For each tumor sample...
  cnvkit.py fix ${SAMPLE}.samtools.targetcoverage.cnn ${SAMPLE}.samtools.antitargetcoverage.cnn ${WRKDIR}/my_reference.samtools.cnn -o ${SAMPLE}.samtools.cnr
  cnvkit.py segment ${SAMPLE}.samtools.cnr -o ${SAMPLE}.samtools.cns
  # Optionally, with --scatter and --diagram
  cnvkit.py scatter ${SAMPLE}.samtools.cnr -s ${SAMPLE}.samtools.cns -o ${SAMPLE}-scatter.samtools.pdf
  cnvkit.py diagram ${SAMPLE}.samtools.cnr -s ${SAMPLE}.samtools.cns -o ${SAMPLE}-diagram.samtools.pdf
  ## Second using barcode-deduped on-target data
  # For each tumor sample...
  cnvkit.py fix ${SAMPLE}.barcode.targetcoverage.cnn ${SAMPLE}.samtools.antitargetcoverage.cnn ${WRKDIR}/my_reference.barcode.cnn -o ${SAMPLE}.barcode.cnr
  cnvkit.py segment ${SAMPLE}.barcode.cnr -o ${SAMPLE}.barcode.cns
  # Optionally, with --scatter and --diagram
  cnvkit.py scatter ${SAMPLE}.barcode.cnr -s ${SAMPLE}.barcode.cns -o ${SAMPLE}-scatter.barcode.pdf
  cnvkit.py diagram ${SAMPLE}.barcode.cnr -s ${SAMPLE}.barcode.cns -o ${SAMPLE}-diagram.barcode.pdf
done
