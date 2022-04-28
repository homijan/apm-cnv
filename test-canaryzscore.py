import openpyxl
import sys
from CNAdefs import *
from weightedmeanvalue import weightedMeanValues

fileName = 'canary-python/results-canary/results-canary-mse/Sample_HSTAMP0054-T1_Tumor.cnvZscores'
# Colun names used in canary output
chrColName = "#chr"; startColName = "start"; endColName = "end"; valueColName = "gc.corrected.norm.log.std.index.zWeighted.Final"
zscores = weightedMeanValues(fileName, chrColName, startColName, endColName, valueColName)
print(f'returned zscores {zscores}')
