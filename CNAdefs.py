# Describe CNA_originals
CNA_original = {}
CNA_original['1p'] = ['chr1', '1p32', 50700001, 61300000]
CNA_original['1q'] = ['chr1', '1q21', 142600001, 155000000]
CNA_original['5q'] = ['chr5', '5q31', 130600001, 144500000]
CNA_original['mono5'] = ['chr5', '5p15.2', 9800001, 15000000]
CNA_original['7q'] = ['chr7', '7q31', 107400001, 127100000]
CNA_original['mono7'] = ['chr7', '7p11.1-q11.1', 58000001, 61700000]
CNA_original['trisomy8'] = ['chr8', '8p11.1-q11.1', 42900001, 48200000] # Milan si delta funkci vycucal z prstu.
#CNA_original['trisomy8'] = ['chr8', '8p11.1-q11.1', 43100001, 48100000]
CNA_original['11q'] = ['chr11', '11q22.3', 102900001, 110400000]
CNA_original['trisomy12'] = ['chr12', '12p11.1', 33200001, 38300000] # Milan si delta funkci vycucal z prstu.
#CNA_original['trisomy12'] = ['chr12', '12p11.1', 33300001, 38200000]
CNA_original['13q'] = ['chr13', '13q14.3', 50900001, 55300000]
CNA_original['17p'] = ['chr17', '17p13.1', 6500001, 10700000]
CNA_original['20q'] = ['chr20', '20q12', 37600001, 41700000]

# Describe CNA_R
CNA_R = {}
CNA_R['1p'] = ['chr1', '1p32.2', 56100000, 59000000]
CNA_R['1q'] = ['chr1', '1q21.2', 147000000, 150300000]
CNA_R['5q'] = ['chr5', '5q31.2', 136200000, 139500000]
CNA_R['mono5'] = ['chr5', '5p15.2', 9800001, 15000000]
CNA_R['7q'] = ['chr7', '7q31', 107400001, 127100000]
CNA_R['mono7'] = ['chr7', '7p11.1-q11.1', 58000001, 61700000]
CNA_R['trisomy8'] = ['chr8', '8p11.1', 43100000, 45600000] 
CNA_R['11q'] = ['chr11', '11q22.3', 102900001, 110400000]
CNA_R['trisomy12'] = ['chr12', '12p11.1', 33300000, 35800000]
CNA_R['13q'] = ['chr13', '13q14.3', 50900000, 55300000]
CNA_R['17p'] = ['chr17', '17p13.1', 6500000, 10700000]
CNA_R['20q'] = ['chr20', '20q12', 37600000, 41700000]

# Describe CNA_arm
CNA_arm = {}
CNA_arm['1p'] = ['chr1', '1p', 0, 125000000]
CNA_arm['1q'] = ['chr1', '1q', 125000000, 150300000]
CNA_arm['5q'] = ['chr5', '5q', 48400000, 180915260]
CNA_arm['mono5'] = ['chr5', '5p15.2', 9800001, 15000000]
CNA_arm['7q'] = ['chr7', '7q', 59900000, 159138663]
CNA_arm['mono7'] = ['chr7', '7p11.1-q11.1', 58000001, 61700000]
CNA_arm['trisomy8'] = ['chr8', '8p',0 , 45600000]
CNA_arm['11q'] = ['chr11', '11q', 53700000, 135006516]
CNA_arm['trisomy12'] = ['chr12', '12p', 0, 35800000]
CNA_arm['13q'] = ['chr13', '13q', 17900000, 115169878]
CNA_arm['17p'] = ['chr17', '17p', 0, 24000000]
CNA_arm['20q'] = ['chr20', '20q', 27500000, 63025520]

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
CNA = CNA_arm
