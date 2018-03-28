# Basic code for batch processing files
# 27 March 2018
# KER

#########################################################################################################
# FUNCTION: FileBuilder
# create a set of random files for regression
# input: fileN = number of files to create
# fileFolder = name of folder for random files
# fileSize = c(min,max), min and max number of rows in a file
# fileNA = number on average of NA per column (make data more realistic)
# output: set of random files
#--------------------------------------------------------------------------------------------------------

FileBuilder<-function(fileN=10,
                      fileFolder="RandomFiles/", # Forward slash in RandomFiles tells R that it's a folder
                      fileSize=c(15,100), 
                      fileNA=3) { 
  for (i in seq_len(fileN)) {
    fileLength<-sample(fileSize[1]:fileSize[2],size=1) # Draw a number at random from this range
    varX<-runif(fileLength) # Random x values
    varY<-runif(fileLength) # Random y values
    dF<-data.frame(varX,varY) # Bind vectors to data frame
    badVals<-rpois(n=1,lambda=fileNA) # Number of NA values that we will use to contaminate data
    dF[sample(nrow(dF),size=badVals),1] <- NA # Inserting NA values into column 1
    dF[sample(nrow(dF),size=badVals),2] <- NA # Replacing different set of values in column 2 with NA
    
    # Create a consecutive, unique file name for each data frame created
    fileLabel<-paste(fileFolder, # paste function creates a character string
                     "ranFile",
                     formatC(i, width=3, format="d", flag="0"),
                     ".csv",
                     sep="") # Pastes components right next to each other with no separation
    
    # Set up data file and incorporate time stamp and minimal metadata
    # Begin each line with the # to indicate comment in file that will be read into R
    
    write.table(cat("# simulated random data file for batch processing","\n", 
                    "# timestamp: ", as.character(Sys.time()),"\n",
                    "# KER","\n",
                    "# _____________________________________________", "\n",
                    "\n",
                    file=fileLabel,
                    row.names="",
                    col.names="",
                    sep=""))
    
    # Add the data frame to the csv
    write.table(x=dF,file=fileLabel,sep=",",row.names=FALSE,append=TRUE) # append adds the data frame to      the metadata instead of overwriting it
                    
  } # close for loop
} # close function


#########################################################################################################
# FUNCTION: regStats
# fit linear model, get regression stats
# input: 2-column data frame
# output: slope, p-value, and r2
#--------------------------------------------------------------------------------------------------------

regStats<-function(d=NULL) {
  if(is.null(d)) { # Minimalist code for default data frame
    xVar<-runif(10)
    yVar<-runif(10)
    d<-data.frame(xVar,yVar)
  }
  .<-lm(data=d,d[,2]~d[,1]) # Creates lm regardless of what the columns are labeled
  .<-summary(.) # The dot serves as a placeholder to keep the lm
  
  statsList<-list(Slope=.$coefficients[2,1],pVal=.$coefficients[2,4],r2=.$r.squared)
  return(statsList)
}

#########################################################################################################

# Start body of program
library(TeachingDemos)
char2seed("Freezing March")

#___________________________________________________________

# Global variables
fileFolder<-"RandomFiles/"
nFiles<-100
fileOut<-"StatsSummary.csv"

# Create 100 random datasets
FileBuilder(fileN=nFiles)

fileNames<-list.files(path=fileFolder) # Creates list of file names to be used in batch processing

# Create data frame to hold file summary statistics (results of batch processing)
ID<-seq_along(fileNames)
fileName<-fileNames
slope<-rep(NA,nFiles) # Empty vector to be filled in by batch processing loop
pVal<-rep(NA,nFiles)
r2<-rep(NA,nFiles)
numbRows<-rep(NA,nFiles)
numbCleanRows<-rep(NA,nFiles)

statsOut<-data.frame(ID,fileName,slope,pVal,r2,numbRows,numbCleanRows)

# Batch process by looping through indvidual files, pulling out summary stats
for (i in seq_along(fileNames)) {
  data<-read.table(file=paste(fileFolder,fileNames[i],sep=""),
                   sep=",",
                   header=TRUE) # Reads in data file
  dClean<-data[complete.cases(data),] # Removes observations (rows) that contain NAs in any column
  .<-regStats(dClean) # Retrieves regression stats from clean file
  statsOut[i,3:5]<-unlist(.) # Deconstructs list and places reg stats in last 3 columns of output file
  statsOut[i,6]<-nrow(data) # Lists the number of rows in the data file before the NAs were removed
  statsOut[i,7]<-nrow(dClean)
}

# Set up output file and incorporate time stamp and minimal metadata
write.table(cat("# Summary stats for batch processing of regression models","\n",
                "# timestamp: ",as.character(Sys.time()),"\n",
                "# KER","\n",
                "# ------------------------", "\n",
                "\n",
                file=fileOut,
                row.names="",
                col.names="",
                sep=""))

# Add the data frame to the file that has been prepped with metadata
write.table(x=statsOut,
            file=fileOut,
            row.names=FALSE,
            col.names=TRUE,
            sep=",",
            append=TRUE)
