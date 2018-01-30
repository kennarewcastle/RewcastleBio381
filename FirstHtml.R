## ----setup, include=FALSE------------------------------------------------
knitr::opts_chunk$set(echo = TRUE) # This sets up echo/eval options GLOBALLY for all chunks in the rest of the file. Can override this default by specifying echo/eval in subsequent chunks.

## ----cars----------------------------------------------------------------
summary(cars)

## ----pressure, echo=FALSE------------------------------------------------
plot(pressure)

## ---- echo=FALSE---------------------------------------------------------
library(ggplot2)
waterTemp<-runif(50)
planktonAbun<-runif(50)
qplot(x=waterTemp,y=planktonAbun) # qplot, unlike the ggplot function, does not require a dataframe
# print(waterTemp)
# head(waterTemp) # head() returns the first 6 entries in a vector to give you a peak at the contents

## ---- echo=TRUE, eval=TRUE, message=FALSE--------------------------------
qplot(x=waterTemp) # Without a y value, qplot produces a histogram of your data.

