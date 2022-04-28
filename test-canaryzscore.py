import openpyxl
import sys
from CNAdefs import *
from canaryZscore import canary_zscore
fileName = 'canary-python/results-canary/results-canary-mse/Sample_HSTAMP0054-T1_Tumor.cnvZscores'
zscores = canary_zscore(fileName)
print(f'returned zscores {zscores}')
