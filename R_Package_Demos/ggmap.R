# ggmap tutorial
# April 25th, 2018
# KER

library(ggmap)
library(rgdal)
library(foreign)
head(read.dbf(file="CountyBoundaries/VTCountyBoundaries.dbf"))

# What is ggmap?
# ggmap goes out to different map servers (like google) and grabs base maps
# raster objects - lets you plot those maps
# much like with ggplot
# can change your coordinate systems and datums
# ?ggmap

# Some example map fetching:
avl<-get_map(location="Asheville, North Carolina") # Gives URL where it got data from, can't give it a state name because the data query is too big
ggmap(avl)

# Different maptypes: "terrain", "toner", "watercolor" (options depend on where map came from)
avl<-get_map(location="Asheville",maptype="toner")
ggmap(avl)

# Certain maptypes for certain sources

# Different sources include google, stamen, OSM (open street maps), if you want a certain map type, will have to get this from a specific source

avl<-get_map(location="Asheville, North Carolina",maptype="watercolor",source="google",zoom=15)
ggmap(avl)

# Change the zoom. Whole numbers 1:21 for google, 1:18 for stamen, 1 is the world, 21 or 18 is house level
YD<-get_map("Yaounde, Cameroon",source="google",maptype="terrain",zoom=11)
ggmap(YD)

# Vermont example with shape files -----------------------------------------------------------------------

# Get a raster object, overset it with a shapefile, and add GPS
# 1: get the map of VT

VT<-get_map("Salisbury, Vermont",zoom=8,maptype="roadmap")
VTMap<-ggmap(VT, extent="normal")
VTMap

# Reading in a VT dtabase file of county boundaries from 
# Vermont Geodata Portal (Free!)
# rad.dbf turns your database file into a data frame
head(read.dbf(file="CountyBoundaries/VTCountyBoundaries.dbf"))

# readOGR is from rgdal package--turns your dta into a usuable spatial vector object
VTcountyB<-readOGR(dsn="CountyBoundaries/VTCountyBoundaries.shp",layer="VTCountyBoundaries")

# Reproject your data's projection/datum
VTcountyB<-spTransform(VTcountyB,CRS("+proj=longlat +datum=WGS84"))

# fortify converts spatial data into a data frame
fortify(VTcountyB)

# Plot the shape file on raster object
VTcountyMap<-VTMap + geom_polygon(aes(x=long,y=lat,group=group),fill="green",size=0.2,color="black",data=VTcountyB,alpha=0.3)

# With GPS coordinates --------------------------------------------------------------------------------

# 5 sites in Vermont
# Read in a table of GPS coords
GPS_Coords<-read.table("GPS_coords.csv",header=TRUE,sep=",",stringsAsFactors = FALSE)

# Use geom_point to plot points on map
VTcountyMap + geom_point(data=GPS_Coords,mapping=aes(x=Lon,y=Lat),color="purple",size=3)
