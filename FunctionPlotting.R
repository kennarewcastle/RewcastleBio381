# Plotting functions, sweeping parameters
# 29 March 2018
# KER

# Use differing numbers of matrix rows and columns just to make placement assignments clearer
z<-matrix(runif(9),nrow=3) # Not ideal, same row x column dimensions
z[3,3]

z<-matrix(runif(20),nrow=5)
z[5,4]
z[4,5] # Throws an error, useful if you get rows v. columns mixed up in your head

# Using double for loops --> can loop over rows or columns
m<-matrix(round(runif(20),digits=2), nrow=5) # Round cuts number of decimal places to 2

# Looping over rows:
for (i in 1:nrow(m)) {
  m[i,]<-m[i,] + i # Operate on the whole row (i)
}

print(m) # Has added the integer index to each element in a row

# Good practice to use different index for operating on rows (i) vs. columns (j)
m<-matrix(round(runif(20),digits=2), nrow=5)

for (j in 1:ncol(m)) {
  m[,j]<-m[,j] + j
}

print(m) # Has added the integer index to each element in a column

# Loop over rows and columns
m<-matrix(round(runif(20),digits=2), nrow=5)

for (i in 1:nrow(m)) {
  for (j in 1:ncol(m)) {
    m[i,j]<-m[i,j] + i + j
  }
}

print (m)

# Sweeping over parameters in an equation: using biogeography species area relationship
# S = cA^z S = species, A = area of an island

##########################################################################################################
# FUNCTION: SpeciesAreaCurve
# creates a power function for the species-area relationship formula (S and A)
# input: A = vector of island areas
#        c = intercept constant
#        z = slope constant
# output: S = vector of species richness values for each island
#--------------------------------------------------------------------------------------------------------

SpeciesAreaCurve<-function(A=1:5000, c=0.5, z=0.26) {
  S<-c*(A^z)
  return(S)
}

# SpeciesAreaCurve()

##########################################################################################################
# FUNCTION: SpeciesAreaPlot
# Plot of relationship between S and A using base graphics
# input: A = vector of island areas
#        c = intercept constant
#        z = slope
# output: base graph with parameter values
#--------------------------------------------------------------------------------------------------------

SpeciesAreaPlot<-function(A=1:5000, c=0.5, z=0.26) {
  
  plot(x=A, y=SpeciesAreaCurve(A=A, c=c, z=z),  # Calls previous function to calculate y values (sp. rich)
       type="l",
       xlab="Island Area",
       ylab="S",
       ylim=c(0,2500))
  
  mtext(paste("c = ",c,"z = ",z),cex=0.7) # mtext= margin text, cex= character expansion (magnification)
       
  return() # Graph will be dumped out, but the output will read "NULL"
}

# Now build a grid of plots, each with different parameter values

# Global variables
cPars<-c(100,150,175)
zPars<-c(0.10,0.16,0.26,0.30)
par(mfrow=c(3,4)) # Will change the graphical parameters for all graphs that are produced afterwards

# Enter into double loop for plotting
for (i in 1:length(cPars)) {
  for (j in 1:length(zPars)) {
    SpeciesAreaPlot(c=cPars[i],z=zPars[j])
  }
}

par(mfrow=c(1,1)) # Reset graphic parameters

# Make plots with ggplot instead of base graphics

# Global variables
cPars<-c(100,150,175)
zPars<-c(0.10,0.16,0.26,0.30)
Area<-1:5

# Set up data frame
modelFrame<-expand.grid(c=cPars,z=zPars,A=Area) # Makes a data frame of every combination of these parameters (60 elements, c*z*A = 60).
modelFrame$S<-NA # Adds an empty column "S" to data frame

# Tricky double for loop for filling new data frame
for(i in 1:length(cPars)) {
  for (j in 1:length(zPars)) {
    modelFrame[modelFrame$c==cPars[i] & modelFrame$z==zPars[j],"S"] <- SpeciesAreaCurve(A=Area,c=cPars[i],z=zPars[j]) # Can call entire columns by their names in quotes
  }
}

modelFrame # Successfully filled our new data frame with species richness values!

library(ggplot2)
p1<-ggplot(data=modelFrame)
p1 + geom_line(mapping=aes(x=A, y=S)) + facet_grid(c~z)

p2<-p1
p2 + geom_line(mapping=aes(x=A, y=S,group=z)) + facet_grid(.~c)

