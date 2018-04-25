# Using openair package
# 25 April 2018
# KER

setwd("~/Documents/School Work/PhD/Computational Biology/RewcastleBio381/R_Package_Demos")

# Designed to nalyze air pollution
# Great for big time series data sets
# Going over four of the plotting functions

# summaryPlot - getting to know your dataset
# timePlot - line graphs of time series
# windRose - wind data
# calendarPlot - wind and water quality data

# Preliminaries
library(openair)
library(dplyr)

# Load the dataset
dbBuoy<-read.csv("HF_MB_forOpenAir.csv")
head(dbBuoy)

# Formatting the timestamp for openair
dbBuoy$date<-as.POSIXct(strptime(dbBuoy$timestamp, format="%m/%d/%Y %H:%M", tz="Etc/GMT-4"))

# Missing days of data, summary stats, distribution of data
summaryPlot(select(dbBuoy, date, windSpeed, CHL_CONC, PC_RFU, wTEMP))

# Change time period to month instead of year
summaryPlot(select(dbBuoy, date, windSpeed, CHL_CONC, PC_RFU, wTEMP), period="months")

# Change resolution to weekly average
summaryPlot(select(dbBuoy, date, windSpeed, CHL_CONC, PC_RFU, wTEMP), period="months", avg.time="week")

# timePlot
timePlot(dbBuoy, pollutant=c("wTEMP", "PC_RFU", "CHL_CONC")) # Really nice way to make graphs stack on one another, see how multiple different parameters change over the same time period

# Put all graphs on one plot instead of individual pannels
timePlot(dbBuoy, pollutant=c("wTEMP", "PC_RFU", "CHL_CONC"), group=TRUE)

# Different y-axes for each plot and stack them, better axes names
timePlot(dbBuoy, pollutant=c("wTEMP", "PC_RFU", "CHL_CONC"), y.relation="free", ref.y=list(h=8,lty=5),name.pol=c("temp (C)", "PC (RFU)", "Chl (ug/L)"))


# windRose (visualize wind direction)
windRose(dbBuoy, ws="windspeed", wd="windDir", type="season")

# calendarPlot (visualize date of high value)
dbBuoy<-rename(dbBuoy, wd=windDir, ws=windSpeed)
calendarPlot(dbBuoy,pollutant = "PC_RFU")

# Customizing colors and adding wind vectors
calendarPlot(dbBuoy,pollutant = "PC_RFU", annotate="ws", cols=c("white", "dodgerblue", "dodgerblue3", "dodgerblue4"))
