import sys
import re

def formatWCFile(fileNameInput):
  # Define proper column separator
  sep='\t'
  with open(fileNameInput) as fIn:
    # Skip all comment lines
    N = 43
    lines_after_intro = fIn.readlines()[N:]
    # Open the output file to write the new chr bedStart bedEnd columns to
    fileNameOutput = fileNameInput[:len(fileNameInput)-4]+'.std.txt'
    fOut = open(fileNameOutput, "w")
    # Write the first line using additional column names
    firstLine = lines_after_intro[0]
    cols = firstLine.split()
    fOut.write(f'{cols[0]}{sep}{cols[1]}{sep}{cols[2]}{sep}chrNum{sep}Start{sep}End\n')
    # Loop over all lines in the input file and write each line with ripped columns into the output file
    for line in lines_after_intro[1:]:
      cols = line.split()
      # Rip the chr:bedStart-bedEnd column into three columns
      c3 = re.split(':|-', cols[3])
      chrNum = c3[0]
      Start = c3[1]
      End = c3[2]   
      fOut.write(f'{cols[0]}{sep}{cols[1]}{sep}{cols[2]}{sep}{chrNum}{sep}{Start}{sep}{End}\n')
  # Close the output file when done
  fOut.close()


fileNameInput = sys.argv[1]

#fileNameInput = 'testSamples/Sample_HSTAMP0100-T1_Tumor.sorted.samtools-deduped.sorted.offtarget.txt'

formatWCFile(fileNameInput)
