import sys
from CNAdefs import *

debug = False
if (debug):
  for cna in cnas:
    print(f'CNA {cna}, chromosome {CNA[cna][iChr]}, cytoband {CNA[cna][iCyt]}, bed-start {CNA[cna][iStart]}, bed-end {CNA[cna][iEnd]}')

fileName = sys.argv[1]
print(f'filename {fileName}')

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
      print(f'CNA {cna}, weighted-mean-cn NA')
    else:
      print(f'CNA {cna}, weighted-mean-cn {cnTotal / bedsizeTotal}')
