# -*- coding: utf-8 -*-
"""
Created on Thu Nov  4 09:51:35 2021

@author: Weihan Yao
"""

import datashader
import hvplot.pandas
import fastparquet
import pandas as pd
import holoviews as hv
hv.extension('bokeh')
renderer = hv.renderer('bokeh')
import pyarrow


##Read household power consumption data
dat = pd.read_csv('data/household_power_consumption.txt', sep=';',header=0)

## dat['Date']=dat['Date'].astype(str)

##Combine date and time
dat["datetime"] = pd.to_datetime(dat["Date"]) + pd.to_timedelta(dat["Time"])
##dat['Global_active_power'] = dat['Global_active_power'].astype(float)

##To numeric
dat['Global_active_power'] = pd.to_numeric(dat['Global_active_power'], errors='coerce')
pic = dat.hvplot.scatter(x = 'datetime',y =  'Global_active_power', groupby = [],datashade=True,title = 'Global Active Power Consumption During 4 Years')

##Save picture
hv.save(pic,'1.html')

##Save data
dat = dat.iloc[:,[2,9]]
dat.to_parquet('power.parquet')
