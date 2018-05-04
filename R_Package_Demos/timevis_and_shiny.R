# timevis and shiny demos
# Diana Hackenburg
# 2 May 2018
# KER

library(timevis)

# timevis is a cool app to build timelines

simpleTL<-data.frame(
  id = 1:4,
  content = c("Randomization Tests", "ggplots", "Homework 12", "Presentations 1"),
  start=c("2018-04-03","2018-04-05", "2018-04-11", "2018-04-24 14:50:00"),
  end=c(NA,"2018-04-17",NA,NA)
)
timevis(simpleTL)

# Add groups
groups <- data.frame( 
  id = c("lec", "hw", "pt"),
  content = c("Lecture", "Homework", "Presentation")
)

# Bind groups to data frame
groupTL <- cbind(simpleTL,group=c(rep("lec",2),"hw","pt"))

# Add groups to final timeline
timevis(groupTL,groups=groups)

# Add item to timeline
# html is supported
# Use "piping notation" to add onto the next command like with leaflet package!

timevis(groupTL,groups=groups)  %>%
  addItem(list(id=5, content="<b>Presentations 2</b>", start="2018-04-25", group="pt")) 

# Add a hyperlink to a timeline item
# First change content from a factor to a character
groupTL$content <- as.character(groupTL$content)

groupTL[3,2] <- "<a href='https://gotellilab.github.io/Bio381/Homeworks/Homework12_2018.html'>Homework 12</a>"

timevis(groupTL,groups=groups)

# Your timeline has options! 
# showZoom = TRUE/FALSE
# Some things are options and must be included as a list
# Make items editable
# Timeline automatically resizes to window but can set height or width

timevis(simpleTL, showZoom=FALSE,options = list(editable = TRUE, width="500px",height = "400px"))

# Add some style
styles <- c("color:white; background-color:black;")

# Styles associated with items or with groups
simpleTL <- cbind(simpleTL,style=styles)
timevis(simpleTL)

# Timeline with prepared data
# Read in data
timedata <- read.csv("timeline_example.csv", header=TRUE,sep=",")

# Create the groups data frame
groups <- data.frame(
  id=c("N","SP","NP","LP","TMDL"),
  content=c("News","State Policy","National Policy","Local Policy","TMDL"),
  # Add style to group
  style=c("background-color:lightblue;","background-color:plum;","background-color:pink;","background-color:khaki;","background-color:coral;"))

# Assign timeline to a vector
# Shortcut "alt" + "-" <- (Mac "Opt" + "-")
# Orientation of timeline axis (this code puts the axis on top)
timevisHAB <- timevis(timedata,groups=groups,options=list(selectable=TRUE,editable=TRUE,verticalScroll=TRUE,horizontalScroll=TRUE,moveable=TRUE,multiselect=TRUE,zoomCtrl=TRUE,maxHeight="500px",orientation="top"))
timevisHAB
