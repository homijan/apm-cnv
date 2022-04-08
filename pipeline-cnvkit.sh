#!/bin/bash
# First activate conda environment `conda activate cnvkit`
# Run `./pipeline-cnvkit.sh < /dev/null &`
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
./generate-cnn.sh
# Generate a pooled normal references from all normal samples. 
# Use barcode target and samtools antitarget for `my_reference.barcode-samtools.cnn`
# *.samtools.antitargetcoverage.cnn + *.barcode.targetcoverage.cnn
cnvkit.py reference ${WRKDIR}/results-cnn-normal/*.{barcode.targetcoverage,samtools.antitargetcoverage}.cnn --fasta ${WRKDIR}/hg19.fa -o ${WRKDIR}/my_reference.barcode-samtools.cnn
# Loop over the tumor.cnn samples
for i in ${WRKDIR}/results-cnn-tumor/*.samtools.antitargetcoverage.cnn
do
  # Trim the string to get a root name of the sample
  SAMPLE="$(echo $i | sed 's/.samtools.antitargetcoverage.cnn//g')"
  echo "Working on sample: $SAMPLE"
  ##  Using barcode-deduped on-target data and samtools-deduped off-target data
  # For each tumor sample...
  if [ ! -f ${SAMPLE}.barcode-samtools.cnr ]; then
    # Make a barcode.antitarget.cnn link using the samtools generated off-target cnn
    ln -s ${SAMPLE}.samtools.antitargetcoverage.cnn ${SAMPLE}.barcode.antitargetcoverage.cnn
    cnvkit.py fix ${SAMPLE}.barcode.targetcoverage.cnn ${SAMPLE}.barcode.antitargetcoverage.cnn ${WRKDIR}/my_reference.barcode-samtools.cnn -o ${SAMPLE}.barcode-samtools.cnr
    cnvkit.py segment ${SAMPLE}.barcode.cnr -o ${SAMPLE}.barcode-samtools.cns
    # Optionally, with --scatter and --diagram
    cnvkit.py scatter ${SAMPLE}.barcode-samtools.cnr -s ${SAMPLE}.barcode-samtools.cns -o ${SAMPLE}-scatter.barcode-samtools.pdf
    cnvkit.py diagram ${SAMPLE}.barcode-samtools.cnr -s ${SAMPLE}.barcode-samtools.cns -o ${SAMPLE}-diagram.barcode-samtools.pdf
  fi
done
