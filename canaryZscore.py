from CNAdefs import *
import pandas as pd

def canary_zscore(fileName):
  # Read the data frame
  df = pd.read_csv(fileName,sep="\t")
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
      iLine = -1
      for line in f:
        iLine = iLine + 1
        cols = line.split()
        # canary file
        chromosome = df["#chr"][iLine]; bedStart = df["start"][iLine]; bedEnd = df["end"][iLine]; cn = df["gc.corrected.norm.log.std.index.zWeighted.Final"][iLine]
        #print(f'iLine {iLine}, cna {cna}, chromosome {chromosome}, start {bedStart}, end {bedEnd}, zScore {cn}, cnTotal {cnTotal}')  
        if (not pd.isna(cn)):
          if (CNA[cna][iChr] == chromosome):
            # Segment smaller than CNA interval
            if (bedStart > CNA[cna][iStart] and bedEnd < CNA[cna][iEnd]):
              bedsize = bedEnd - bedStart
              cnTotal = cnTotal + cn * bedsize
              bedsizeTotal = bedsizeTotal + bedsize
              if (debug):
                print(f'CNA {cna}, chromosome {chromosome}, bed-start {bedStart}, bed-end {bedEnd}')
                print(f'CNA {cna}, cn {cn}, bedsize {bedsize}')
            # CNA interval smaller than segment
            if (CNA[cna][iStart] >= bedStart and CNA[cna][iEnd] <= bedEnd):
              bedsize = CNA[cna][iEnd] - CNA[cna][iStart]
              cnTotal = cnTotal + cn * bedsize
              bedsizeTotal = bedsizeTotal + bedsize
              if (debug):
                print(f'CNA {cna}, chromosome {chromosome}, bed-start {bedStart}, bed-end {bedEnd}')
                print(f'CNA {cna}, cn {cn}, bedsize {bedsize}')
            # Overlap of CNA interval and segment
            else:
              if (CNA[cna][iStart] >= bedStart and CNA[cna][iStart] <= bedEnd):
                bedsize = bedEnd - CNA[cna][iStart]
                cnTotal = cnTotal + cn * bedsize
                bedsizeTotal = bedsizeTotal + bedsize
                if (debug):
                  print(f'CNA {cna}, chromosome {chromosome}, bed-start {bedStart}, bed-end {bedEnd}')
                  print(f'CNA {cna}, cn {cn}, bedsize {bedsize}')
              if (CNA[cna][iEnd] >= bedStart and CNA[cna][iEnd] <= bedEnd):
                bedsize = CNA[cna][iEnd] - bedStart
                cnTotal = cnTotal + cn * bedsize
                bedsizeTotal = bedsizeTotal + bedsize
                if (debug):
                  print(f'CNA {cna}, chromosome {chromosome}, bed-start {bedStart}, bed-end {bedEnd}')
                  print(f'CNA {cna}, cn {cn}, bedsize {bedsize}')   
    # Mark cn as anavailable
    if (cnTotal==0):
      w_cn = 'NA'
      print(f'CNA {cna}, weighted-mean-cn NA')
    else:
      print(f'CNA {cna}, weighted-mean-cn {cnTotal / bedsizeTotal}')
      w_cn = cnTotal / bedsizeTotal
    w_cns[cna] = w_cn
    #print(f'CNA {cna}, weighted-mean-cn {w_cn}')
  return w_cns
