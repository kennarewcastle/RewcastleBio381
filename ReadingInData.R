# Archetype experimental designs, dta entry, analysis, and graphing in R

#data<-read.table(file="Filename.csv",row.names=1,header=TRUE,sep=",",stringAsFactors=FALSE) 

# Very important to use read.table not read.csv because this allows the ## comments to be ignored when reading data in. The row.names indicator allows R to name your rows given then "ID" column in your data sheet so you can call out specific rows in the data set by the ID number when subsetting. Setting stringAsFactors = FALSE prevents major problems, set them as factors later after reading in the data.

# Omit NA values initially to streamline stats later.

#dataClean<-data[complete.cases(data),] # This will give us all the columns in rows that have no missing values.

#dataClean<-data[complete.cases(data[,5:6]),] # All rows with no NAs in columns 5 and 6 (allows NAs in other columns)

library(TeachingDemos)
char2seed('espresso',set=FALSE)
