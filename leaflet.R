install.packages("leaflet") 
install.packages("maps")
library(leaflet)
library(maps)
library(TeachingDemos)
char2seed("Professor Looney")
dF <- read.csv("leafletData30.csv")
dF2 <- read.csv("leafletData500.csv")
cities <- read.csv("cities.csv")

# Leaflet() creates a map widget that can store variables to be modified later on
# addTiles() adds mapping data from "open street map"
# %>%: takes an output and add onto the next command (cool piping notation)
# as the first argument, and reassign it to the next variable

# Create a simple map
my_map<-leaflet() %>%
  addTiles()

my_map

# Adding different types of maps onto my_map
my_map<-leaflet() %>%
  addTiles() %>%
  addProviderTiles(providers$Esri.WorldImagery)

my_map

# Adding markers
map<-my_map %>%
  addMarkers(lat=44.4764,lng=-73.1955)

map

# Give a label to our marker
map<-my_map %>%
  addMarkers(lat=44.4764,lng=-73.1955,popup="Bio381 Classroom")
map

df<-data.frame(lat=runif(20, min=44.4770, max=44.4793), lng=runif(20, min=-73.18788, max=-73.18203))

head(df)

df %>% leaflet() %>% addTiles() %>% addMarkers()

# Read in .csv file
markers<-data.frame(lat=dF$lat,lng=dF$lng)

markers %>% leaflet() %>% addTiles() %>% addMarkers()

# Adding legends
df<-data.frame(col=sample(c("red","blue","green"),20,replace=TRUE),stringAsFactors=FALSE)

markers %>% leaflet() %>% addTiles() %>% addCircleMarkers(color=df$col) %>% addLegend(labels=c("A.rubrum","T. canadensis","P. strobum"), colors=c("red","blue","green"))

# Making clusters
cluster<-data.frame(lat=dF2$lat,lng=dF2$lng)

cluster %>% leaflet() %>% addTiles() %>% addMarkers()

# Cluster instead of data on top of one another

cluster %>% leaflet() %>% addTiles() %>% addMarkers(clusterOptions=markerClusterOptions())

# Creating custom markers 
uvmIcon <- makeIcon(iconUrl = "UVM.jpg", # call the image
                    iconWidth = 31*215/230,
                    iconHeight= 31,
                    iconAnchorX= 31*215/230/2,
                    iconAnchorY= 16
) # what i found to be the best length,height,width for marker
UVMLatLong <- data.frame(
  lat= c(44.4779),
  lng= c(-73.1965)) # lat & lng for your data point 
UVMLatLong %>%
  leaflet()%>%
  addTiles()%>%
  addMarkers(icon= uvmIcon) # what icon do u want

# Adding polygons
mapStates<-map("state",fill=TRUE,plot=FALSE)

leaflet(data=mapStates) %>% addTiles() %>% addPolygons(fillColor=topo.colors(10,alpha=NULL),stroke=FALSE)

# Circles
print(cities)
leaflet(cities) %>% addTiles %>% addCircles(lng = ~long, lat= ~lat, weight=1, radius=~sqrt(pop)*30, popup=~city)
