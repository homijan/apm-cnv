# Describe CNA_originals
CNA_original = {}
CNA_original['1p'] = ['chr1', '1p32', 50700001, 61300000]
CNA_original['1q'] = ['chr1', '1q21', 142600001, 155000000]
CNA_original['5q'] = ['chr5', '5q31', 130600001, 144500000]
CNA_original['mono5'] = ['chr5', '5p15.2', 9800001, 15000000]
CNA_original['7q'] = ['chr7', '7q31', 107400001, 127100000]
CNA_original['mono7'] = ['chr7', '7p11.1-q11.1', 58000001, 61700000]
CNA_original['trisomy8'] = ['chr8', '8p11.1-q11.1', 43100001, 48100000]
CNA_original['11q'] = ['chr11', '11q22.3', 102900001, 110400000]
CNA_original['trisomy12'] = ['chr12', '12p11.1', 33300001, 38200000]
CNA_original['13q'] = ['chr13', '13q14.3', 50900001, 55300000]
CNA_original['17p'] = ['chr17', '17p13.1', 6500001, 10700000]
CNA_original['20q'] = ['chr20', '20q12', 37600001, 41700000]

# Describe CNA_paper
CNA_paper = {}
CNA_paper['1p'] = ['chr1', '1p32', 50700001, 61300000]
CNA_paper['1q'] = ['chr1', '1q21', 142600001, 155000000]
CNA_paper['5q'] = ['chr5', '5q31', 131892957, 138269817]
CNA_paper['mono5'] = ['chr5', '5p15.2', 1, 180915260]
CNA_paper['7q'] = ['chr7', '7q31', 105507981, 116436182]
CNA_paper['mono7'] = ['chr7', '7p11.1-q11.1', 1, 159138663]
CNA_paper['trisomy8'] = ['chr8', '8p11.1-q11.1', 1, 146364022]
CNA_paper['11q'] = ['chr11', '11q22.3', 102900001, 110400000]
CNA_paper['trisomy12'] = ['chr12', '12p11.1', 33300001, 38200000]
CNA_paper['13q'] = ['chr13', '13q14.3', 50900001, 55300000]
CNA_paper['17p'] = ['chr17', '17p13.1', 6500001, 10700000]
CNA_paper['20q'] = ['chr20', '20q12', 40709452, 41818422]

# Indexes to CNA_original values
iChr = 0; iCyt = 1; iStart = 2; iEnd = 3

# Define list of CNA_originals to loop over
cnas = ['1p', '1q', '5q', '7q', 'trisomy8', '11q', 'trisomy12', '13q', '17p', '20q']

# Different cnv file formats
cnvkitFormat = 'cnvkitFormat'
ichorcnaRegionFormat = 'ichorcnaRegionFormat'
ichorcnaSegmentFormat = 'ichorcnaSegmentFormat'

# Define which CNA to use
CNA = CNA_paper
