# Intro to ggplot Part 2
# April 10 2018
# KER

# Preliminaries
library(ggplot2)
library(ggthemes)
library(patchwork) # Not in CRAN, out in github, check with Lauren to get it set up
library(TeachingDemos)

char2seed("10th Avenue Freeze-Out")

d<-mpg # mpg is a built-in data set

#-------------------------------------------------------------------------------------------------------- 

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


