# apm-cnv
The cnvkit and ichorcna pipelines for cfDNA

Postprocessing of canary, cnvkit, ichorcna and wisecondor results for cfDNA

### Apply necessary formating to wisecondor results
`for i in wisecondor/testSamples/Sample_HSTAMP*-T1_Tumor.sorted.samtools-deduped.sorted.offtarget.txt; do python3 wisecondorFormatter.py $i; done`
