# Data Wrangling Tricks
# 19 April 2018
# KER


# Preliminaries

library(reshape2)
library(tidyr)
library(dplyr)
library(ggplot2)
library(TeachingDemos)
char2seed("Sharpei")

species<-5
sites<-8
abundanceRange<-1:10
mFill<-0.4

vec<-rep(0,species*sites) # Set up empty vector
abun<-sample(x=abundanceRange,size=round(mFill*length(vec)),replace=TRUE)
vec[seq_along(abun)]<-abun # Puts abundance vector in the first entries for vec
vec<-sample(vec) # Reshuffles contents of vec (default is replace=FALSE)

aMat<-matrix(vec,nrow=species) # Creates a matrix from our vector

rownames(aMat)<-rownames(aMat,do.NULL=FALSE,prefix="Species")
colnames(aMat)<-colnames(aMat,do.NULL=FALSE,prefix="Site")

# We've built a matrix with sites in the columns and count data for individual species in each row. This is called the wide format, but we want it to be in long form or "tidy form" in order to analyze this in R.

# Use `melt` function from reshape2 package to convert matrix to long form. ***** MELT ONLY WORKS FOR MATRICES

.<-melt(aMat)
print(.) # Each row is an element in the original aMat data
.<-melt(aMat,varnames=c("Species","Site"),value.name="Abundance")

aFrame<-data.frame(cbind(Species=rownames(aMat),aMat)) # Create a dataframe that we will transform

.<-gather(aFrame,Site1:Site8,key="Site",value="Abundance")
print(.)
.$Abundance<-as.numeric(.$Abundance) # Converts from character element to numeric element

aFrameL<-. # Dataframe is now in the long form

# Now able to do a bar plot with this
ggplot(aFrameL,aes(x=Site,y=Abundance,fill=Species)) +
  geom_bar(position="dodge",stat="identity",color="black") # Removing "position" would stack the bars on top of each other instead of producing a group of 5 different colored bars for each site.

# Build a subject by time experimental matrix
Treatment<-rep(c("Control","Treatment"),each=5)
Subject<-1:10
T1<-rnorm(10) # These represent response variables
T2<-rnorm(10)
T3<-rnorm(10)

eFrame<-data.frame(Treatment=Treatment,Subject=Subject,T1=T1,T2=T2,T3=T3)

.<-gather(eFrame,T1:T3,key="Time",value="Response")
print(.)
.$Time<-as.factor(.$Time) # Need to coerce into factor in order to use it to group data in figure below

eFrameL<-.

# Ready for boxplot
ggplot(eFrameL,aes(x=Treatment,y=Response,fill=Time)) + geom_boxplot()

# Now change them back to the wide format
.<-dcast(aFrameL,Species~Site,value="Abundance")
print(.) # Note that in the format of dataframe, not a matrix

.<-spread(aFrameL,key=Site,value=Abundance)
print(.)

# summarize and group_by from dplyr package
as.data.frame(summarize(mpg,ctyM=mean(cty),ctySD=sd(cty))) # Gives summary for entire data set, but you are really interested in group-level summary statistics

.<-group_by(mpg,fl)
as.data.frame(summarize(.,ctyM=mean(cty),ctySD=sd(cty))) # Gives mean and sd for city MPG of each fuel type group (mpg is variable of interest, fl is what groups will be defined by)

as.data.frame(summarize(.,ctyM=mean(cty),ctySD=sd(cty),n=length(cty))) # Added number of city MPG observations for each fuel type group

.<-group_by(mpg,fl,class)
as.data.frame(summarize(.,ctyM=mean(cty),ctySD=sd(cty),n=length(cty)))

.<-filter(mpg,class!="suv") # Excludes suv from dataset
.<-group_by(.,fl,class)
as.data.frame(summarize(.,ctyM=mean(cty),ctySD=sd(cty),n=length(cty)))

# replicate(n,expression,simpligy)
# n = number of desired iterations of a function
# expression is any r expression or function
# simplify defaulty="array" with 1 more dimension than original input, simplify=TRUE gives vector or matrix, simplify=FALSE gives a list

# First set up matrix
myOut<-matrix(data=0,nrow=3,ncol=5)

# Fill using a for loop (dumb coding)
for (i in 1:nrow(myOut)) {
  for (j in 1:ncol(myOut)) {
    myOut[i,j]<-runif(1)
  }
}

myOut<-matrix(data=runif(15),nrow=3) # Much more efficient

mO<-replicate(n=5,
              100 + runif(3), # DO NOT USE expression = ....., just dump in the expression!
              simplify=TRUE)
 
mO<-replicate(n=5,
              matrix(runif(6),3,2),
              simplify="array") # Produces a list of five 3x2 matrices

print(mO[,,3]) # Tells R to print the entire 3rd matrix in the list
