# Import Library

#import pandas as pd 
import matplotlib.pyplot as plt 


# Plot multiple columns bar chart

data = pd.read_table('cnvkit-segment-MDS-tableSE.txt', delimiter=" ")
df = pd.DataFrame(data, columns=["Name","English","Hindi","Maths", "Science", "Computer"])

df.plot(x="Lesion", y=["Sensitivity","Specificity"], kind="bar",figsize=(9,8))

# Show

plt.show()