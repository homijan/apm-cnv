from CNAdefs import *
import pandas as pd

# Obtain weighted-mean value based on overlap of clinical deletion/gain and CNV intervals in bed coordinates
def canary_zscore(fileName):
  chrColName = "#chr"; startColName = "start"; endColName = "end"; valueColName = "gc.corrected.norm.log.std.index.zWeighted.Final"
  # Read the data frame
  df = pd.read_csv(fileName,sep="\t")
  debug = False
  w_values = {}
  for cna in cnas:
    if (debug):
      print(f'CNA bed interval [{CNA[cna][iStart]}, {CNA[cna][iEnd]}]')
    dfChr = df[df[chrColName]==CNA[cna][iChr]]
    valueTotal = 0
    bedsizeTotal = 0 #1e-32 # Numerical zero
    for index, row in dfChr.iterrows():
      # Assign CNV bed coordinates
      bedStart = row[startColName]; bedEnd = row[endColName] 
      # Assign value to obtain weighted-mean for
      value = row[valueColName]
      if (debug):
        # Auxilliary variable
        chromosome = row[chrColName]
      if (not pd.isna(value)):
        # Segment smaller than CNA interval
        if (bedStart > CNA[cna][iStart] and bedEnd < CNA[cna][iEnd]):
          bedsize = bedEnd - bedStart
          valueTotal = valueTotal + value * bedsize
          bedsizeTotal = bedsizeTotal + bedsize
          if (debug):
            print(f'CNA {cna}, chromosome {chromosome}, bed-start {bedStart}, bed-end {bedEnd}')
            print(f'CNA {cna}, value {value}, bedsize {bedsize}')
        # CNA interval smaller than segment
        if (CNA[cna][iStart] >= bedStart and CNA[cna][iEnd] <= bedEnd):
          bedsize = CNA[cna][iEnd] - CNA[cna][iStart]
          valueTotal = valueTotal + value * bedsize
          bedsizeTotal = bedsizeTotal + bedsize
          if (debug):
            print(f'CNA {cna}, chromosome {chromosome}, bed-start {bedStart}, bed-end {bedEnd}')
            print(f'CNA {cna}, value {value}, bedsize {bedsize}')
        # Overlap of CNA interval and segment
        else:
          if (CNA[cna][iStart] >= bedStart and CNA[cna][iStart] <= bedEnd):
            bedsize = bedEnd - CNA[cna][iStart]
            valueTotal = valueTotal + value * bedsize
            bedsizeTotal = bedsizeTotal + bedsize
            if (debug):
              print(f'CNA {cna}, chromosome {chromosome}, bed-start {bedStart}, bed-end {bedEnd}')
              print(f'CNA {cna}, value {value}, bedsize {bedsize}')
          if (CNA[cna][iEnd] >= bedStart and CNA[cna][iEnd] <= bedEnd):
            bedsize = CNA[cna][iEnd] - bedStart
            valueTotal = valueTotal + value * bedsize
            bedsizeTotal = bedsizeTotal + bedsize
            if (debug):
              print(f'CNA {cna}, chromosome {chromosome}, bed-start {bedStart}, bed-end {bedEnd}')
              print(f'CNA {cna}, value {value}, bedsize {bedsize}')   
    # Mark value as anavailable
    if (valueTotal==0):
      w_value = 'NA'
      print(f'CNA {cna}, weighted-mean-value NA')
    else:
      print(f'CNA {cna}, weighted-mean-value {valueTotal / bedsizeTotal}')
      w_value = valueTotal / bedsizeTotal
    w_values[cna] = w_value
    #print(f'CNA {cna}, weighted-mean-value {w_value}')
  return w_values
