#!/bin/bash
# Run `./pipeline-cnvkit-normals.sh < /dev/null &`
# Note: `./pipeline-cnvkit.sh < /dev/null &` needs to be run beforehand
# Directory for cnvkit computations
WRKDIR=$PWD
echo "Working in $WRKDIR"

# Loop over the tumor.cnn samples
for i in ${WRKDIR}/results-cnn-normal/*.samtools.antitargetcoverage.cnn
do
  # Trim the string to get a root name of the sample
  SAMPLE="$(echo $i | sed 's/.samtools.antitargetcoverage.cnn//g')"
  echo "Working on sample: $SAMPLE"
  ## Using barcode-deduped on-target data
  # For each tumor sample...
  if [ ! -f ${SAMPLE}.barcode-samtools.cnr ]; then
    # Make a barcode.antitarget.cnn link using the samtools generated off-target cnn
    ln -s ${SAMPLE}.samtools.antitargetcoverage.cnn ${SAMPLE}.barcode.antitargetcoverage.cnn
    cnvkit.py fix ${SAMPLE}.barcode.targetcoverage.cnn ${SAMPLE}.barcode.antitargetcoverage.cnn ${WRKDIR}/my_reference.barcode.cnn -o ${SAMPLE}.barcode-samtools.cnr
    cnvkit.py segment ${SAMPLE}.barcode-samtools.cnr -o ${SAMPLE}.barcode-samtools.cns
    # Optionally, with --scatter and --diagram
    cnvkit.py scatter ${SAMPLE}.barcode-samtools.cnr -s ${SAMPLE}.barcode-samtools.cns -o ${SAMPLE}-scatter.barcode-samtools.pdf
    cnvkit.py diagram ${SAMPLE}.barcode-samtools.cnr -s ${SAMPLE}.barcode-samtools.cns -o ${SAMPLE}-diagram.barcode-samtools.pdf
  fi
done
