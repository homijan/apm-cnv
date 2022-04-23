from CNAdefs import *

def weightedCN(fileName, fileFormat):
  debug = False
  w_cns = {}
  for cna in cnas:
    if (debug):
      print(f'CNA bed interval [{CNA[cna][iStart]}, {CNA[cna][iEnd]}]')
    with open(fileName) as f:
      # Skip the first line
      next(f)
      cnTotal = 0
      bedsizeTotal = 1e-32 # Numerical zero
      # Loop over all lines
      for line in f:
        cols = line.split()
        if (fileFormat==cnvkitFormat):
          # cnvkit file
          chromosome = cols[0]; bedStart = int(cols[1]); bedEnd = int(cols[2]); log2 = cols[4]; cn = int(cols[5])
        elif (fileFormat==ichorcnaRegionFormat):
          # ichorcna .cna.seg
          chromosome = 'chr'+str(cols[0]); bedStart = int(cols[1]); bedEnd = int(cols[2]); cn = int(cols[3]); cnCorrected = int(cols[6])
        elif (fileFormat==ichorcnaSegmentFormat):
          # ichorcna .seg
          # TODO check the cols indexes
          chromosome = 'chr'+str(cols[0]); bedStart = int(cols[1]); bedEnd = int(cols[2]); cn = int(cols[3]); cnCorrected = int(cols[6])
      
        if (CNA[cna][iChr] == chromosome):
          # Segment smaller than CNA interval
          if (bedStart > CNA[cna][iStart] and bedEnd < CNA[cna][iEnd]):
            bedsize = bedEnd - bedStart
            cnTotal = cnTotal + cn * bedsize
            bedsizeTotal = bedsizeTotal + bedsize
            if (debug):
              print(f'CNA {cna}, chromosome {chromosome}, bed-start {bedStart}, bed-end {bedEnd}')
              print(f'CNA {cna}, cnCorrected {cnCorrected}, cn {cn}, bedsize {bedsize}')
          # CNA interval smaller than segment
          if (CNA[cna][iStart] >= bedStart and CNA[cna][iEnd] <= bedEnd):
            bedsize = CNA[cna][iEnd] - CNA[cna][iStart]
            cnTotal = cnTotal + cn * bedsize
            bedsizeTotal = bedsizeTotal + bedsize
            if (debug):
              print(f'CNA {cna}, chromosome {chromosome}, bed-start {bedStart}, bed-end {bedEnd}')
              print(f'CNA {cna}, cnCorrected {cnCorrected}, cn {cn}, bedsize {bedsize}')
          # Overlap of CNA interval and segment
          else:
            if (CNA[cna][iStart] >= bedStart and CNA[cna][iStart] <= bedEnd):
              bedsize = bedEnd - CNA[cna][iStart]
              cnTotal = cnTotal + cn * bedsize
              bedsizeTotal = bedsizeTotal + bedsize
              if (debug):
                print(f'CNA {cna}, chromosome {chromosome}, bed-start {bedStart}, bed-end {bedEnd}')
                print(f'CNA {cna}, cnCorrected {cnCorrected}, cn {cn}, bedsize {bedsize}')
            if (CNA[cna][iEnd] >= bedStart and CNA[cna][iEnd] <= bedEnd):
              bedsize = CNA[cna][iEnd] - bedStart
              cnTotal = cnTotal + cn * bedsize
              bedsizeTotal = bedsizeTotal + bedsize
              if (debug):
                print(f'CNA {cna}, chromosome {chromosome}, bed-start {bedStart}, bed-end {bedEnd}')
                print(f'CNA {cna}, cnCorrected {cnCorrected}, cn {cn}, bedsize {bedsize}')
    # Mark cn as anavailable
    if (cnTotal==0):
      cnTotal = 'NA'
      print(f'CNA {cna}, weighted-mean-cn NA')
    #else:
    #  print(f'CNA {cna}, weighted-mean-cn {cnTotal / bedsizeTotal}')
    w_cn = cnTotal / bedsizeTotal
    w_cns[cna] = w_cn
    #print(f'CNA {cna}, weighted-mean-cn {w_cn}')
  return w_cns
