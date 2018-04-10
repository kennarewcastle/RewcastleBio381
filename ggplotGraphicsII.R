# Intro to ggplot Part 2
# April 10 2018
# KER

# Preliminaries
library(ggplot2)
library(ggthemes)
library(patchwork) 
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

# Third graph
g3<-ggplot(data=d,mapping=aes(x=displ,fill=I("royalblue"),color=I("black"))) + geom_histogram()

print(g3)             

# Fourth graph
g4<-ggplot(data=d,mapping=aes(x=fl,y=cty,fill=fl)) + geom_boxplot() + theme(legend.position="none")

print(g4)

# Patchwork for awesome multipanel graphs

# Place two plots horizontally
g1 + g2

# Place 3 plots vertically (in 1 column)
g1 + g2 + g3 + plot_layout(ncol=1)

# Change relative area of each plot
g1 + g2 + plot_layout(ncol=1,heights=c(2,1)) # Makes 1st plot twice as high as 2nd plot in grid.

g1 + g2 + plot_layout(ncol=2,widths=c(2,1))

# Add a spacer plot (under construction)
g1 + plot_spacer() + g2 # Gives blank space between two plots, but annoying grey background of invisible plot remains

# Set up nested plot
g1 + {
  g2 + {
    g3 +
      g4 +
      plot_layout(ncol=1)
  }
} +
  plot_layout(ncol=1)

# - operator for subtrack placement

g1 + g2 - g3 + plot_layout(ncol=1) # Places graph 3 on it's own row beneath g1 and g2

# / | for very intuitive layouts
(g1 | g2 | g3) / g4

(g1 | g2) / (g3 | g4)

# Swapping axis orientation within a plot
g3a<-g3 + scale_x_reverse()

g3b<- g3 + scale_y_reverse()

g3c<- g3 + scale_x_reverse() + scale_y_reverse()

(g3 | g3a) / (g3b | g3c)

# Switch orientation of coordinates
(g3 + coord_flip() | g3a + coord_flip()) / (g3b + coord_flip() | g3c + coord_flip())

# ggsave for creating and saving plots
ggsave(filename="MyPlot.pdf",plot=g3,width=20,height=20,units="cm",dpi=300)

# Mapping of variables to aesthetics
m1<-ggplot(data=mpg,mapping=aes(x=displ,y=cty,color=class)) + geom_point() # displ, cty, and class are variables that we are mapping to specific aesthetic parameters)

print(m1)

# Limited to 6 different point shapes
m1<-ggplot(data=mpg,mapping=aes(x=displ,y=cty,shape=class)) + geom_point() 
print(m1)

# Mapping of a discrete variable to point size
m1<-ggplot(data=mpg,mapping=aes(x=displ,y=cty,size=class)) + geom_point()
print(m1)

# Mapping of a continuous variable to point size
m1<-ggplot(data=mpg,mapping=aes(x=displ,y=cty,size=hwy)) + geom_point()
print(m1)

# Map a continuous variable onto color
m1<-ggplot(data=mpg,mapping=aes(x=displ,y=cty,color=hwy)) + geom_point() 
print(m1)

# Map two variables to two different aesthetics
m1<-ggplot(data=mpg,mapping=aes(x=displ,y=cty,shape=class,color=hwy)) + geom_point() # Essentially brings in 4 aspects of the data into 1 graph... Probably not advised.

# Map three variables to two different aesthetics
m1<-ggplot(data=mpg,mapping=aes(x=displ,y=cty,shape=drv,color=fl,size=hwy)) + geom_point()
print(m1)

# Mapping a variavle to the same aesthetic for two different geoms
m1<-ggplot(data=mpg,mapping=aes(x=displ,y=cty,color=drv)) + geom_point() + geom_smooth(method="lm")
print(m1)

# Faceting for better visulation in a set of related plots
m1<-ggplot(data=mpg,mapping=aes(x=displ,y=cty)) +
    geom_point() +
    theme_fivethirtyeight()

print(m1)

m1 + facet_grid(class~fl) # Shows the cty~displ relationship for each combination of fl and class. Class = individual rows, fl = columns, subsets data for each graph

m1 + facet_grid(class~fl,scales="free_y") # Allows scale of y axis to change for each row in the grid; shows spread of data but makes comparisons harder

# Facet on only a single variable (subgroups based on 1 variable)
m1 + facet_grid(.~class) # "." indicates that you don't want to facet along the rows
m1 + facet_grid(class~.)

# Use facet_wrap for unordered graphs
m1 + facet_wrap(~class) # Looks better than stretched out graphs stacked in columns or rows

# Combine variables in a facet wrap
m1 + facet_wrap(~class + fl)

m1 + facet_wrap(~class + fl, drop=FALSE) # Included the variable combinations that are empty

# Use facet in combination with aesthetics
m1<-ggplot(data=mpg,mapping=aes(x=displ,y=cty,color=drv)) + geom_point()

m1 + facet_wrap(~class) # Maintains the drv color classification in each facet panel

m1<-ggplot(data=mpg,mapping=aes(x=displ,y=cty,color=drv)) + geom_smooth(method="lm",se=FALSE) # Removes confidence intervals
m1 + facet_grid(.~class)

# Fitting with boxplots over a continous variable
m1<-ggplot(data=mpg,mapping=aes(x=displ,y=cty)) + geom_boxplot()
m1 + facet_grid(.~class)
