# Intro to ggplot
# April 5 2018
# KER

# Preliminaries
library(ggplot2)
library(ggthemes)
library(patchwork) # Not in CRAN, out in github, check with Lauren to get it set up
library(TeachingDemos)

char2seed("10th Avenue Freeze-Out")

d<-mpg # mpg is a built-in data set

#---------------------------------------------------------------------------------------------------------

# qplots for use while coding, eliminates need for dataframe

# Basic histogram
qplot(x=d$hwy) # Makes a histogram with relative ease.

# Density plot
qplot(x=d$hwy,geom="density")

# Basic scatter plot
qplot(x=d$displ, y=d$hwy, geom=c("smooth","point"))

qplot(x=d$displ, y=d$hwy, geom=c("smooth","point"),method="lm") # lm passes information to the smoother

# Basic boxplot
qplot(x=d$fl, y=d$cty, geom="boxplot")

# Basic barplot
qplot(x=d$fl,geom="bar",fill=I("green"))

qplot(x=d$fl,geom="bar",fill=I("green")) # Using fill=("green") without the I will fuck up your code, the way I typed is using fill as mapping

# Plotting curves and functions

myVec<-seq(from=1,to=100,by=0.1)
myFun<-function(x) {sin(x) + 0.1*x}

# Plot built in functions
qplot(x=myVec,y=sin(myVec), geom="line")

# Plot density distributions for probability functions
qplot(x=myVec,y=dgamma(myVec, shape=5, scale=3), geom="line")

# Plot user defined functions
qplot(x=myVec,y=myFun(myVec), geom="line") # Looks like CO2 increase curve over many years, with seasonal cycles in CO2 due to photosynthesis in the Northern Hemisphere

#----------------------------------------------------------------------------------------------------

p1<-ggplot(data=d, mapping=aes(x=displ,y=cty)) + geom_point()
print(p1)

p1 + theme_classic() # No grid lines!

p1 + theme_linedraw() # Black frame with less grid lines

p1 + theme_dark() # Looks good if you use brightly colored data points

p1 + theme_par() # Uses current par settings

p1 + theme_base() # Looks like base R graphics

p1 + theme_void() # Only data

p1 + theme_solarized() # Background is kind of ivory colored

p1 + theme_economist() # Many specialized themes, this one looks like a stock market trends map


# Use theme parameters to modify font and font size

p1 + theme_classic(base_size=30, base_family="sans") # base_family accepts name of font, base_size adjusts font size (labels and axes numbers)

p2 <- ggplot(data=d, mapping=aes(x=fl,fill=fl)) + geom_bar()
print(p2)

# Flip the two coordinate axes (ie turn graph on it's size to make it more legible)
p2 + coord_flip() + theme_classic(base_size=20,base_family="Courier")

# Minor theme modifications
p1<-ggplot(data=d, mapping=aes(x=displ,y=cty)) + 
  geom_point(size=5,shape=21,color="black",fill="coral")

print(p1)
        
p1<-ggplot(data=d, mapping=aes(x=displ,y=cty)) + 
  geom_point(size=5,shape=21,color="black",fill="coral") +
  ggtitle("Mygraph title here")

print(p1)

p1<-ggplot(data=d, mapping=aes(x=displ,y=cty)) + 
  geom_point(size=5,shape=21,color="black",fill="coral") +
  ggtitle("My graph title here") +
  xlab("My x axis label") +
  ylab("My y axis label") +
  xlim(0,4) + ylim(0,20) # Including x and y limits is a useful way to subset data without alterting dataframe

print(p1)  

#----------------------------------------------------------------------------------------------------

# Create 4 individual graphs that will be included in one composite plot using patchwork

# First graph
g1<-ggplot(data=d, mapping=aes(x=displ,y=cty)) +
  geom_point() +
  geom_smooth()

print(g1)

# Second graph
g2<-ggplot(data=d,mapping=aes(x=fl,fill=I("tomato"),color=I("black"))) +
  geom_bar(stat="count") +
  theme(legend.position="none") # Gets rid of legend so that it isn't in the way when we patch graphs together

print(g2)
