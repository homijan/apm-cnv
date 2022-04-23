# Describe CNAs
CNA = {}
CNA['1p'] = ['chr1', '1p32', 50700001, 61300000]
CNA['1q'] = ['chr1', '1q21', 142600001, 155000000]
CNA['5q'] = ['chr5', '5q31', 130600001, 144500000]
CNA['mono5'] = ['chr5', '5p15.2', 9800001, 15000000]
CNA['7q'] = ['chr7', '7q31', 107400001, 127100000]
CNA['mono7'] = ['chr7', '7p11.1-q11.1', 58000001, 61700000]
CNA['trisomy8'] = ['chr8', '8p11.1-q11.1', 43100001, 48100000]
CNA['11q'] = ['chr11', '11q22.3', 102900001, 110400000]
CNA['trisomy12'] = ['chr12', '12p11.1', 33300001, 38200000]
CNA['13q'] = ['chr13', '13q14.3', 50900001, 55300000]
CNA['17p'] = ['chr17', '17p13.1', 6500001, 10700000]
CNA['20q'] = ['chr20', '20q12', 37600001, 41700000]
# Indexes to CNA values
iChr = 0; iCyt = 1; iStart = 2; iEnd = 3

# Define list of CNAs to loop over
cnas = ['1p', '1q', '5q', '7q', 'trisomy8', '11q', 'trisomy12', '13q', '17p', '20q']

# Different cnv file formats
cnvkitFormat = 'cnvkitFormat'
ichorcnaRegionFormat = 'ichorcnaRegionFormat'
ichorcnaSegmentFormat = 'ichorcnaSegmentFormat'
