# Run generate-off-ontarget-normal.sh to generate offtarget and index files from normal samples
# Run generate-wig-normal.sh to generate wig files from normal samples
WRKDIR=$PWD
ICHORDIR="/drive3/aliciapm/ichorCNA"
if [ ! -f ${WRKDIR}/reference-normal_median.rds ]; then
  echo "File ${WRKDIR}/reference-normal_median.rds does not exist."
  # Create a text file listing wig files of normal samples
  ls ${WRKDIR}/files-normal/*.wig > normal-wigs.txt
  # Call R and run the script
  Rscript  ${ICHORDIR}/scripts/createPanelOfNormals.R --filelist normal-wigs.txt --gcWig ${ICHORDIR}/inst/extdata/gc_hg19_1000kb.wig --mapWig ${ICHORDIR}/inst/extdata/map_hg19_1000kb.wig --centromere ${ICHORDIR}/inst/extdata/GRCh37.p13_centromere_UCSC-gapTable.txt --outfile ${WRKDIR}/reference-normal
fi


