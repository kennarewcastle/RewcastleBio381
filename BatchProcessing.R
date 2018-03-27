# Basic code for batch processing files
# 27 March 2018
# KER

##########################################################################################################
# FUNCTION: FileBuilder
# create a set of random files for regression
# input: fileN = number of files to create
# fileFolder = name of folder for random files
# fileSize = c(min,max), min and max number of rows in a file
# fileNA = number on average of NA per column (make data more realistic)
# output: set of random files
#---------------------------------------------------------------------------------------------------------

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
                    
  }
}
