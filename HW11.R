# Homework 11
# Function Plotting and Randomization Tests
# KER

# Creating functions to graphically show how individual parameters in the Michaelis-Menten equation for enzyme kinetics affect the shape of the function.

# V0 = Vmax([S]/([S]+Km)) 
# V0 = rate of enzymatic reaction
# Vmax = maximum rate of enzymatic reaction
# [S] = concentration of enzyme substrate
# Km = Michaelis-Menten constant, binding affinity of substrate for a specific enzyme given environmental conditions; small Km = high affinity

# In a plot of V0~[S] where V0 ranges from 0 to Vmax, Km = [S] at Vmax/2.


####################################################################################################
# FUNCTION: MMenzyme
# creates a mathematical relationship between S and V
# input: S = a vector of substrate concentrations (micro moles/L)
#        K = the Michaelis-Menton constant for a specific enzymatic reaction (binding affinity) (micro              moles/L)
#        Vmax = max reaction rate constant (umol product/h)
# output: V = a vector of reaction rates umol product/h
#---------------------------------------------------------------------------------------------------
MMenzyme <- function(S=1:100, K=100, Vmax=1){ # Defaults based on Km for the enzyme Pepsin
  
  V<-Vmax*(S/(S+K))
  return(V)
}

#---------------------------------------------------------------------------------------------------

# MMenzyme()

####################################################################################################
# Function: MMenzymePlot
# Plot substrate vs. reaction rate curve with parameter values
# input: S = a vector of substrate concentrations (micro moles/L)
#        K = the Michaelis-Menton constant for a specific enzymatic reaction (binding affinity) (micro    #        moles/L)
#        Vmax = max reaction rate constant (umol product/h)
# output: Smoothed curve with parameters in graph
#---------------------------------------------------------------------------------------------------

MMenzymePlot <- function(S=1:100, K=100, Vmax=1) {
  plot(x=S,y=MMenzyme(S,K,Vmax),type="l",xlab="Substrate Concentration (umol/L)",ylab="Reaction Rate (umol product/h)",ylim=c(0,1.5))
  mtext(paste("Km = ", K,"  Vmax = ", Vmax), cex=0.7) 
  return("Plot created")
}

#---------------------------------------------------------------------------------------------------

MMenzymePlot()

#---------------------------------------------------------------------------------------------------

# Build a grid of plots with multiple K and Vmax values

# Global variables
KPars<-c(10,100,200)
VmaxPars<-c(0.1,0.8,1.0,1.5)
par(mfrow=c(3,4)) # Will change the graphical parameters for all graphs that are produced afterwards

# Enter into double loop for plotting
for (i in 1:length(KPars)) {
  for (j in 1:length(VmaxPars)) {
    MMenzymePlot(S=0:1000,K=KPars[i],Vmax=VmaxPars[j])
  }
}

par(mfrow=c(1,1)) # Reset graphic parameters

#---------------------------------------------------------------------------------------------------

# Use ggplot instead of base graphics

# Global variables
KPars<-c(10,100,200)
VmaxPars<-c(0.1,0.8,1.0,1.5)
Sub<-seq(from=0,to=800,by=200)  # Limits substrate levels to 5 values

# Set up data frame
modelFrame<-expand.grid(K=KPars,Vmax=VmaxPars,S=Sub) # Makes a data frame of every combination of these parameters (60 elements, c*z*A = 60).
modelFrame$V<-NA # Adds an empty column "V" to data frame that will hold output V rates

# Double `for loop` for filling new data frame
for(i in 1:length(KPars)) {
  for (j in 1:length(VmaxPars)) {
    modelFrame[modelFrame$K==KPars[i] & modelFrame$Vmax==VmaxPars[j],"V"] <- MMenzyme(S=Sub,K=KPars[i],Vmax=VmaxPars[j])
  }
}

modelFrame # Successfully filled our V column in new data frame with reaction rate values!

library(ggplot2)
p1<-ggplot(data=modelFrame)
p1 + geom_line(mapping=aes(x=S, y=V)) + facet_grid(K~Vmax)

p2<-p1
p2 + geom_line(mapping=aes(x=S, y=V,group=Vmax)) + facet_grid(.~K)
