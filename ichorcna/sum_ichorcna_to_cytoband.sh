# Extension of janlukas's script `/drive3/janlukas/scripts/sum_ichorcna_to_cytoband.sh` 
#!/bin/bash
# Run `${PATH2SCRIPT}/sum_cnr_to_cytoband.sh < /dev/null &`
# Directory for ichorcna computations
WRKDIR=$PWD
echo "Working in $WRKDIR"

# Loop over the .correctedDepth.txt samples
for file in ${WRKDIR}/results-ichorcna*/*.correctedDepth.txt
do
  # Cut .correctedDepth.txt extenstion
  NAME="$(echo $file | sed 's/.correctedDepth.txt//g')"
  # Jan's sequence of magic
  tail -n +2 ${NAME}.correctedDepth.txt > ${NAME}.tmp.bed
  
  # Merge cytoban bed with *.correctedDepth.txt file
  # Adjusted lukas's file /drive3/janlukas/index/cytobands-noXY-noheader.txt
  bedtools intersect -a ${WRKDIR}/cytobands-noXY-noheader.txt -b ${NAME}.tmp.bed -wo > ${NAME}.tmp
  
  # summarize Median log2 on cytband level
  Rscript ${WRKDIR}/sum_ichorcna_to_cytoband.R ${NAME}.tmp ${NAME}.cytoban.Medianlog2.txt 
  
  # Remove temporary files
  rm ${NAME}.tmp.bed
  #rm ${NAME}.tmp
done



# This script converts bins from a correctedDepth.txt from ichorcna output and merged it with cytobands (wo XY chr) and calculate median log2 -- JLB 04/08/2022
# Must run in the directory of *.cnr file 

# $1=INPUTFILE   ### -.correctedDepth.txt
# $2= SAMPLE #### cfDNA, Normal or Tumor


#name=$(echo $1 | awk -F '[..]' '{print $1}')
#sample=$(echo $2)

#tail -n +2 ${name}.correctedDepth.txt > Sample_${name}_${sample}.temp1.bed

#awk 'OFS="\t" {if (NR > 5) $1="chr"$1; print}' Sample_${name}_${sample}.temp1.bed > Sample_${name}_${sample}.temp2.bed


# Merge cytoban bed with *.cnr file
#bedtools intersect -a /drive3/janlukas/index/cytobands-noXY-noheader.txt -b Sample_${name}_${sample}.temp2.bed -wo > Sample_${name}_${sample}.temp3

# summarize Median log2 on cytband level
#Rscript /drive3/janlukas/scripts/sum_ichorcna_to_cytoband.R Sample_${name}_${sample}.temp3 Sample_${name}_${sample}.cytoband.ichorcna.Medianlog2.txt 

#rm Sample_${name}_${sample}.temp1.bed
#rm Sample_${name}_${sample}.temp2.bed
#rm Sample_${name}_${sample}.temp3

