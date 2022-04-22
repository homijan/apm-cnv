from CNAdefs import *

def cnvkitWeightedCN(fileName):
  # Indexes to CNA values
  iChr = 0; iCyt = 1; iStart = 2; iEnd = 3
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
        chromosome = cols[0]; bedStart = int(cols[1]); bedEnd = int(cols[2]); log2 = cols[4]; cn = int(cols[5])
        if (CNA[cna][iChr] == chromosome):
          # Segment smaller than CNA interval
          if (bedStart > CNA[cna][iStart] and bedEnd < CNA[cna][iEnd]):
            bedsize = bedEnd - bedStart
            cnTotal = cnTotal + cn * bedsize
            bedsizeTotal = bedsizeTotal + bedsize
            if (debug):
              print(f'CNA {cna}, chromosome {chromosome}, bed-start {bedStart}, bed-end {bedEnd}')
              print(f'CNA {cna}, log2 {log2}, cn {cn}, bedsize {bedsize}')
          # CNA interval smaller than segment
          if (CNA[cna][iStart] >= bedStart and CNA[cna][iEnd] <= bedEnd):
            bedsize = CNA[cna][iEnd] - CNA[cna][iStart]
            cnTotal = cnTotal + cn * bedsize
            bedsizeTotal = bedsizeTotal + bedsize
            if (debug):
              print(f'CNA {cna}, chromosome {chromosome}, bed-start {bedStart}, bed-end {bedEnd}')
              print(f'CNA {cna}, log2 {log2}, cn {cn}, bedsize {bedsize}')
          # Overlap of CNA interval and segment 
          else:
            if (CNA[cna][iStart] >= bedStart and CNA[cna][iStart] <= bedEnd):
              bedsize = bedEnd - CNA[cna][iStart]
              cnTotal = cnTotal + cn * bedsize
              bedsizeTotal = bedsizeTotal + bedsize
              if (debug):
                print(f'CNA {cna}, chromosome {chromosome}, bed-start {bedStart}, bed-end {bedEnd}')
                print(f'CNA {cna}, log2 {log2}, cn {cn}, bedsize {bedsize}')
            if (CNA[cna][iEnd] >= bedStart and CNA[cna][iEnd] <= bedEnd):
              bedsize = CNA[cna][iEnd] - bedStart
              cnTotal = cnTotal + cn * bedsize
              bedsizeTotal = bedsizeTotal + bedsize
              if (debug):
                print(f'CNA {cna}, chromosome {chromosome}, bed-start {bedStart}, bed-end {bedEnd}')
                print(f'CNA {cna}, log2 {log2}, cn {cn}, bedsize {bedsize}')
    w_cn = cnTotal / bedsizeTotal
    w_cns[cna] = w_cn
    #print(f'CNA {cna}, weighted-mean-cn {w_cn}')
  return w_cns
