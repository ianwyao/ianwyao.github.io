# -*- coding: utf-8 -*-
"""
Created on Fri Oct 22 11:26:23 2021

@author: Weihan Yao
"""
import pandas as pd

##Loop read every selected files in a folder
##Append them into a new dataframe
final_df = pd.DataFrame()
for i in ['07','12']:
    for j in range(1,31):
        df = pd.read_csv('./04_sm_csv/04/2012-'+i+'-'+str(j).rjust(2,'0')+'.csv',header = None)
        temp = df.loc[df[[0]].idxmax()]
        temp2 = temp[[0,4]]
        temp2['month'] = i 
        temp2['seconds'] = temp2.index
        temp2['time'] = temp2['seconds']/3600
        temp2['date'] = str(j).rjust(2,'0')
        final_df = pd.concat([final_df,temp2])

##Plot bubble graph    
import plotly
import plotly.express as px
from plotly.offline import plot
import plotly.graph_objs as go
fig = px.scatter(final_df, x="time", y=0,
	             color="month",size = 4,
                 hover_name="date",size_max = 40,title="Maximum real power and neutral current consumption in a day",
                 labels = {'time': 'Time (hours)','0':'Sum of real power over all phases','4':'Neutral current'})

plot(fig, auto_open=True)



