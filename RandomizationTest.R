# Randomization test for regression data
# 3 April 2018
# KER

# Preliminaries
library(ggplot2)
library(TeachingDemos)
char2seed("Cruel April") # Sets seed of random number generator

##########################################################################################################
# FUNCTION: readData
# Read in or generate data frame
# input: z= file name (or nothing for demo)
# output: 3-column data frame of observed data (ID, x, y)
#---------------------------------------------------------------------------------------------------------

readData<-function(z=NULL) {
  if(is.null(z)) {
    xVar<-1:20
    yVar<-xVar + 10*rnorm(20)
    z<-data.frame(ID=seq_along(xVar),xVar,yVar)
  }
  return(z)
}

#---------------------------------------------------------------------------------------------------------

# readData()

##########################################################################################################
# FUNCTION: getMetric
# calculate the metric for randomization test
# input: 3-column data frame for regression
# output: regression slope
#---------------------------------------------------------------------------------------------------------

getMetric<-function(z=NULL) {
  if(is.null(z)) {
    xVar<-1:20
    yVar<-xVar + 10*rnorm(20)
    z<-data.frame(ID=seq_along(xVar),xVar,yVar)
  }
  .<-lm(z[,3]~z[,2])
  .<-summary(.)
  .<-.$coefficients[2,1] # pulls out the regression slope from the linear model
  slope<-.
  return(slope)
}

#---------------------------------------------------------------------------------------------------------

# getMetric()

##########################################################################################################
# FUNCTION: shuffleData
# Randomize data for regression analysis
# input: 3-column data frame (ID, xVar, yVar)
# output: Reshuffled 3-column data frame (ID, xVar, yVar)
#---------------------------------------------------------------------------------------------------------

shuffleData<-function(z=NULL) {
  if(is.null(z)) {
    xVar<-1:20
    yVar<-xVar + 10*rnorm(20)
    z<-data.frame(ID=seq_along(xVar),xVar,yVar)
  }
  z[,3]<-sample(z[,3]) # Reshuffles contents of y vector, default of sample is replace=FALSE
  return(z)
}

#---------------------------------------------------------------------------------------------------------

# shuffleData()

##########################################################################################################
# FUNCTION: getPVal
# Calculate p value for observed, simulated data
# input: list of observed metric (single number, Xobs) and vector of simulated metric (Xsim)
# output: lower, upper tail probability vector (2-element vector that gives proporation of Xsim data above and below the value of Xobs)
#---------------------------------------------------------------------------------------------------------

getPVal<-function(z=NULL) {
  if(is.null(z)) {
   z<-list(xObs=runif(1),xSim=runif(1000)) # Fake data set for observed and simulated metrics
  }
  pLower<-mean(z[[2]]<=z[[1]]) # Mean value of Xsims that are less than or equal to Xobs
  pUpper<-mean(z[[2]]>=z[[1]]) 
  return(c(pL=pLower,pU=pUpper))
}

#--------------------------------------------------------------------------------------------------------

# getPVal()

#########################################################################################################
# FUNCTION: plotRanTest
# ggplot graph
# input: list of observed metric and vector of simulated metric
# output: ggplot graph
#--------------------------------------------------------------------------------------------------------

plotRanTest<-function(z=NULL) {
  if(is.null(z)) {
    z<-list(xObs=runif(1),xSim=runif(1000)) # Fake data set for observed and simulated metrics
  }
  
  dF<-data.frame(ID=seq_along(z[[2]]),simX=z[[2]])
  
  p1<-ggplot(data=dF,mapping=aes(x=simX))
  p1 + geom_histogram(mapping=aes(fill=I("goldenrod"),color=I("black"))) + geom_vline(aes(xintercept=z[[1]],col="blue"))
  
}

#--------------------------------------------------------------------------------------------------------

plotRanTest()

#--------------------------------------------------------------------------------------------------------

# Main body of code
nSim<-1000 # Number of simulations
Xsim<-rep(NA,nSim) # Will hold simulated slopes

dF<-readData()
Xobs<-getMetric(z=dF)

for (i in seq_len(nSim)) {
  Xsim[i] <-getMetric(shuffleData(dF)) # Shuffles data and calculates slope for shuffled data at each iteration
}

slopes<-list(Xobs,Xsim) # Compiles these values into list needed for final function

getPVal(slopes) # Xobs lies in far right tail of distribution of Xsims 

plotRanTest(slopes)

