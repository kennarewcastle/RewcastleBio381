# lubridate demo
# Kyle Dittmer
# 2 May 2018

# Great package for formatting and manipulating dates/time series data.

library(lubridate)

# Use base R for comparison
date<-as.POSIXct("02-05-2018",format = "%d-%m %Y", tz="UTC")

# Use lubridate
date<-dmy("01-05-2018", tz="UTC")
month(date)<-3

# Find out what day it was 29 days ago
date<-dmy("02-05-2018", tz="America/New_York") # enter today's date
date<-date - days(29)

# Find the duration between two dates
span<-interval(ymd("2009-01-01"),ymd("2009-08-01"))
as.duration(span)

