# Extension of janlukas's script `/drive3/janlukas/scripts/sum_cnr_to_cytoband.sh` 
#!/bin/bash
# Run `${PATH2SCRIPT}/sum_cnr_to_cytoband.sh < /dev/null &`
# Directory for cnvkit computations
WRKDIR=$PWD
echo "Working in $WRKDIR"

# Loop over the copy-number-region (cnr) samples in results-cnn-tumor and results-cnn-normal
for cnrfile in ${WRKDIR}/results-cnn-*/*.cnr
do
  # Cut .cnr extenstion
  NAME="$(echo $cnrfile | sed 's/.cnr//g')"
  # Jan's sequence of magic
  tail -n +2 ${NAME}.cnr > ${NAME}.tmp.bed
  # Merge cytoban bed with *.cnr file
  bedtools intersect -a /drive3/janlukas/index/cytobands-noXY-noheader.txt -b ${NAME}.tmp.bed -wo > ${NAME}.tmp
  # summarize Median log2 on cytband level
  Rscript ${WRKDIR}/sum_cnvkit-cnr_to_cytoband_log2.R ${NAME}.tmp ${NAME}.cytoban.Medianlog2.txt 
  # Remove temporary files
  rm ${NAME}.tmp.bed
  #rm ${NAME}.tmp
done
