import pandas as pd
import matplotlib.pyplot as plt

cnvkit_segment_MDS = pd.read_table('cnvkit-segment-MDS-tableSE.txt', delimiter=" ")
cnvkit_segment_CLL = pd.read_table('cnvkit-segment-CLL-tableSE.txt', delimiter=" ")
cnvkit_segment_MM = pd.read_table('cnvkit-segment-MM-tableSE.txt', delimiter=" ")

ichorcna_segment_MDS = pd.read_table('ichorcna-segment-MDS-tableSE.txt', delimiter=" ")
ichorcna_segment_CLL = pd.read_table('ichorcna-segment-CLL-tableSE.txt', delimiter=" ")
ichorcna_segment_MM = pd.read_table('ichorcna-segment-MM-tableSE.txt', delimiter=" ")

labelsMDS = ['-5q', '-7q', '-20q', '+8']
labelsCLL = ['-11q', '-13q', '-17p', '+12']
labelsMM = ['-1p', '+1q', '-13q', '-17p']

dataframes = {}
dataframes['cnvkit-segment-MDS-tableSE'] = [cnvkit_segment_MDS, labelsMDS]
dataframes['cnvkit-segment-CLL-tableSE'] = [cnvkit_segment_CLL, labelsCLL]
dataframes['cnvkit-segment-MM-tableSE'] = [cnvkit_segment_MM, labelsMM]
dataframes['ichorcna-segment-MDS-tableSE'] = [ichorcna_segment_MDS, labelsMDS]
dataframes['ichorcna-segment-CLL-tableSE'] = [ichorcna_segment_CLL, labelsCLL]
dataframes['ichorcna-segment-MM-tableSE'] = [ichorcna_segment_MM, labelsMM]


x = [0, 1, 2, 3]
for key in dataframes:
  df = dataframes[key][0]
  labels = dataframes[key][1]  
  df.plot(x="Lesion", y=["Sensitivity", "Specificity"], kind="bar",figsize=(7,7), colormap='tab10')
  plt.xticks(x, labels, size = 20, rotation = 0 )
  plt.legend(loc=(0.8,1))
  plt.gca().spines['right'].set_color('none')
  plt.gca().spines['top'].set_color('none')
  plt.xlabel("")
  plt.savefig(key+'.png')
