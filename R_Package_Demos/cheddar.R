# cheddar demo
# April 25th, 2018
# KER

# cheddar works with community data

# Preliminaries
library(cheddar)

# Load data
data("TL84")

# Break dataset into three .csv files that cheddar needs

# Properties
# Create community directory
dir.create("TL84")

# Create vectors for each field in properties
title= "Tuesday Lake Sampled in 1984"
N.units="m^3"
M.units="kg"
lat=46.21667
long=89.533333
habitat="Freshwater pelagic"

# Making a data frame with vectors
properties<-data.frame(title,N.units,M.units,lat,long,habitat)

# Write csv of properties
write.csv(properties,file="TL84/properties.csv",row.names=FALSE) # Creates a TL84 folder

# Nodes
# Create vectors
node=TL84$nodes$node

# cheddar has a really nice function to collapse the community by any of these categories
M = TL84$nodes$M
N = TL84$nodes$N
kingdom = TL84$nodes$kingdom
phylum = TL84$nodes$phylum
class = TL84$nodes$class
order = TL84$nodes$order
family = TL84$nodes$family
genus = TL84$nodes$genus
species = TL84$nodes$species

# Making a data frame with vectors 
nodes<-data.frame(node,
                  M, N, kingdom, phylum, class, order, family, genus, species)
head(nodes)

# Write csv
write.csv(nodes, file="TL84/nodes.csv", row.names=FALSE)

# Trophic.links (row for resource and row for consumers eating that resource)
# Create a vector
resource=TL84$trophic.links$resource
consumer=TL84$trophic.links$consumer

# Data frame
trophic.links<-data.frame(resource,consumer)

# Write csv
write.csv(trophic.links, file="TL84/trophic.links.csv",row.names=FALSE)

# Loading our dataset (compiling all of the individual .csv)
TL84<-LoadCommunity("./TL84",fn="read.csv")

# Load data for example
data("ChesapeakeBay")
head(ChesapeakeBay$trophic.links)

# Abundance vs mass (network connection overlay)
PlotNvM(TL84,col=1,pch=19,highlight.nodes=NULL,show.web=TRUE) # plots numerical abundance vs. mass

PlotNvM(TL84,col=1,pch=19,highlight.nodes='Daphnia pulex',show.web=TRUE) # Highlights 1 species node

# Code below highlights nodes and corresponding links in different colors
node.names<-TL84$nodes$node
for (i in 1:length(node.names)){
  if(node.names[i]=='Daphnia pulex'){
    node.names[i] <- "red"
  } else if(node.names[i]=='Trichocerca cylindrica'){
    node.names[i] <- "blue"
  } else {
    node.names[i] <- "darkgrey"
  }
}

trophic.links<-TL84$trophic.links
trophic.links$color<-"black"
for (i in 1:nrow(trophic.links)){
  if((trophic.links[i,1] =='Daphnia pulex' | trophic.links[i,2] =='Daphnia pulex' )){
    trophic.links[i,3] <- "red"
  } else if((trophic.links[i,1] =='Trichocerca cylindrica'| trophic.links[i,2] =='Trichocerca cylindrica')){
    trophic.links[i,3] <- "blue"
  } else {
    trophic.links[i,3] <- "grey"
  }
}

PlotNvM(TL84,
        col=node.names,
        link.col=trophic.links$color,
        pch=16,
        highlight.nodes=NULL
)

# Food web by level plot
# Comparing prey-averaged and chain-averaged trophic levels

par(mfrow=c(1,2))
PlotWebByLevel(TL84,ylim=c(1,5.8),level='PreyAveragedTrophicLevel',main="Prey-Averaged",col=1,pch=19,highlight.nodes=NULL)
PlotWebByLevel(TL84,ylim=c(1,5.8),level='ChainAveragedTrophicLevel',main="Chain-Averaged",col=1,pch=19,highlight.nodes=NULL)

# Comparing the three different xlayouts
par(mfrow=c(1,3))
for(x.layout in c('skinny', 'narrow', 'wide'))
{
  PlotWebByLevel(TL84, x.layout=x.layout, main=x.layout, col=1, pch=19, highlight.nodes=NULL)
}

# Compare the effect of staggering levels
par(mfrow=c(1,2))

# No staggering - stagger and max.nodes.per.row are ignored
PlotWebByLevel(TL84, y.layout='compress',col=1, pch=19)

# Stagger
PlotWebByLevel(TL84, y.layout='stagger', stagger=0.1,col=1, pch=19,
               max.nodes.per.row=20)

# Highlight pulex
PlotWebByLevel(TL84, y.layout='stagger', stagger=0.1,col=1, pch=19,highlight.nodes='Daphnia pulex',
               max.nodes.per.row=20)  # just node
PlotWebByLevel(TL84, y.layout='stagger', stagger=0.1,col=1, pch=19, highlight.nodes='Daphnia pulex', highlight.links=TrophicLinksForNodes(TL84, 'Daphnia pulex'), max.nodes.per.row=20) # node and trophic links

par(mfrow=c(1,1))

# Chesapeake Bay Data, Symbolizing Lengths
data(ChesapeakeBay)

# Plot basic food web
PlotWebByLevel(ChesapeakeBay,
               col=1,
               pch=20,
               highlight.nodes=NULL)

# Develop link line widths based on biomass flow
# log transform for graphical representation
link.lwd=log(ChesapeakeBay$trophic.links$biomass.flow)

# Plot food web with link weights
PlotWebByLevel(ChesapeakeBay,
               col=1,
               pch=19,
               highlight.nodes=NULL,
               link.lwd=link.lwd,
               main="Chesapeake Bay Weighted by Flow"
)
