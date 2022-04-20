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
# baits.bed -> /drive3/cfDNA/selectors/Heme-STAMP_SEP2017.bed
ln -s /drive3/cfDNA/selectors/Heme-STAMP_SEP2017.bed baits.bed
# Output: `baits.target.bed` and `baits.antitarget.bed`
./generate-beds.sh | tee generate-beds.out
# Generate cnn files from all the samples 
# Tumor samples < 201 -> WRKDIR/results-cnn-tumor, Normal samples >=201 -> WRKDIR/results-cnn-normal
mkdir results-cnn-tumor 
mkdir results-cnn-normal
./generate-cnn.sh
# Generate a pooled normal references from all normal samples. 
# Use samtools-deduped target and antitarget for `my_reference.samtools.cnn`
cnvkit.py reference ${WRKDIR}/results-cnn-normal/*.{targetcoverage,antitargetcoverage}.cnn --fasta ${WRKDIR}/hg19.fa -o ${WRKDIR}/my_reference.samtools.cnn

# Genereate CNV output for tumor.cnn samples
# Loop over all *.cnn in the results dir of tumors
for i in ${WRKDIR}/results-cnn-tumor/*.samtools.antitargetcoverage.cnn
do
  # Trim the string to get a root name of the sample
  SAMPLE="$(echo $i | sed 's/.samtools.antitargetcoverage.cnn//g')"
  echo "Working on sample: $SAMPLE"
  ##  Using samtools-deduped on-target and off-target data
  # For each tumor sample...
  if [ ! -f ${SAMPLE}.samtools.cnr ]; then
    cnvkit.py fix ${SAMPLE}.samtools.targetcoverage.cnn ${SAMPLE}.samtools.antitargetcoverage.cnn ${WRKDIR}/my_reference.samtools.cnn -o ${SAMPLE}.samtools.cnr
    cnvkit.py segment ${SAMPLE}.samtools.cnr -o ${SAMPLE}.samtools.cns
    # Optionally, with --scatter and --diagram
    cnvkit.py scatter ${SAMPLE}.samtools.cnr -s ${SAMPLE}.samtools.cns -o ${SAMPLE}-scatter.samtools.pdf
    cnvkit.py diagram ${SAMPLE}.samtools.cnr -s ${SAMPLE}.samtools.cns -o ${SAMPLE}-diagram.samtools.pdf
  fi
done

# Double-check CNV output for normal.cnn samples
# Loop over all *.cnn in the results dir of normals
for i in ${WRKDIR}/results-cnn-normal/*.samtools.antitargetcoverage.cnn
do
  # Trim the string to get a root name of the sample
  SAMPLE="$(echo $i | sed 's/.samtools.antitargetcoverage.cnn//g')"
  echo "Working on sample: $SAMPLE"
  ##  Using samtools-deduped on-target and off-target data
  # For each tumor sample...
  if [ ! -f ${SAMPLE}.samtools.cnr ]; then
    cnvkit.py fix ${SAMPLE}.samtools.targetcoverage.cnn ${SAMPLE}.samtools.antitargetcoverage.cnn ${WRKDIR}/my_reference.samtools.cnn -o ${SAMPLE}.samtools.cnr
    cnvkit.py segment ${SAMPLE}.samtools.cnr -o ${SAMPLE}.samtools.cns
    # Optionally, with --scatter and --diagram
    cnvkit.py scatter ${SAMPLE}.samtools.cnr -s ${SAMPLE}.samtools.cns -o ${SAMPLE}-scatter.samtools.pdf
    cnvkit.py diagram ${SAMPLE}.samtools.cnr -s ${SAMPLE}.samtools.cns -o ${SAMPLE}-diagram.samtools.pdf
  fi
done

# Genereate CNV output for tumor.cnn samples
# Loop over all *.cnn in the results dir of tumors
for i in ${WRKDIR}/results-cnn-tumor/*.samtools.antitargetcoverage.cnn
do
  # Trim the string to get a root name of the sample
  SAMPLE="$(echo $i | sed 's/.samtools.antitargetcoverage.cnn//g')"
  echo "Calling on sample: $SAMPLE"
  ##  Using samtools-deduped on-target and off-target data
  # For each tumor sample...
  if [ ! -f ${SAMPLE}.samtools.call.cns ]; then
    cnvkit.py call ${SAMPLE}.samtools.cns
    # Move the call file to the result directory
    mv ${SAMPLE}.samtools.cns ${WRKDIR}/results-cnn-tumor/
  fi
done
