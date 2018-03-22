# Illustrate a break function with a program for a random walk (the value next time depends on the value this time), population growth and allele frequency with genetic drift are biological applications.
# March 22 2018
# KER


##########################################################################################################
# FUNCTION: RanWalk
# stochastic random walk
# input: times = number of time steps
# n1 = initial population size (=n[1])
# lambda = finite rate of increase (multiplier variable)
# noiseSD = standard deviation of a normal distribution with a mean of 0
# output: vector 'n' with population sizes > 0
#---------------------------------------------------------------------------------------------------------
library(ggplot2)
library(tcltk)

RanWalk<-function(times=100, n1=50, lambda=1.0, noiseSD=10) {
  n<-rep(NA,times)
  n[1]<-n1
  noise<-rnorm(n=times,mean=0,sd=noiseSD)
  for (i in 1:(times-1)) {
    n[i+1] <- n[i]*lambda + noise[i]
    if (n[i+1] <= 0) {
      n[i+1]<-NA
      cat("Population extinction at time ",i,"\n")
      #tkbell() # Plays a noise when population goes extinct
      break # Exits out of the loop because the population has gone extinct
    }
  }
  n<-n[complete.cases(n)] # Removes NAs piled up at the end of the vector if population went extinct.
  return(n)
}

z<-RanWalk()
qplot(x=seq_along(z),y=z,geom=c("line","point"))
