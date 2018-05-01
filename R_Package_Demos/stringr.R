# stringr demo
# Adrian Wiegman
# 1 May 2018
# KER

library(tidyverse)
library(openxlsx)

# stringr is basically a set of 40 string manipulation functions

# I. Define Functions --------------------------------------------
# pkg.info() 
# returns list of info on loaded non-base R packages
pkg.info <- function() sessionInfo()$otherPkgs
pkg.info()

# pkg.names() 
# returns character vector of load non-base R packages
pkg.names <- function() names(sessionInfo()$otherPkgs)
pkg.names()

# require.pkgs()
# checks to see if packages are installed, installs and loads
require.pkgs <- function(p='vector of package names'){
  if(!is.element(p,installed.packages()[,1])){
    install.packages(p,character.only=TRUE)}
  require(p,character.only=TRUE)
}
require.pkgs()

# detach.pkgs()
# detaches all non-base R packages
detach.pkgs <- function(){
  . <- menu(c("Yes", "No"),title="Do you want to detach all packages?")
  if(.!=1){stop('function aborted')}else{
    lapply(paste('package:',names(sessionInfo()$otherPkgs),sep=""),detach,character.only=TRUE,unload=TRUE)
  }
}

# file.remove.warning
# insert warning requiring user feedback before deleting files
file.remove.warning <- function(x=NULL){
  xfiles <- paste(x,collapse=', ')
  warning <- paste("WARNING: Do you want to delete",xfiles,"from the following path? \n",getwd())
  . <- menu(c("Yes", "No"),title=warning)
  if(.!=1){stop('function aborted')}else{
    cat("deleting files...")
    file.remove(x)
  }
}
file.remove.warning()

# parent.dir()
# returns the parent of working directory
parent.dir <- function(){
  x <- getwd()
  # get names of subdirectories
  x <- str_split(x,"/") %>% unlist()
  # get path minus working directory folder 
  x <- str_c(x[-length(x)],collapse='/')
  return(x)
}
parent.dir()

# II. Preliminaries ----------------------------------------------
# Detach non-base R packages
detach.pkgs()
pkg.names()

#load a vector of packages 
. <- 'tidyverse' # c('stringr','readr')
require.pkgs(.)
pkg.names()
# tidyverse loads `stringr` `readr` `plyr` `ggplot2` etc..

# set starting dir
START <- getwd()

# III. `stringr` practice ---------------------------

# start by getting some strings to work with 

# vector of package names
s1 <- pkg.names()

# capture.output() of console as character vector 
s2 <- capture.output(pkg.info())
s2 

# this list is a little long lets subset a random sample 
set.seed(1) 
s3 <- sample(s2,5,replace=TRUE)


# every function starts with `str_`
# most functions have logical names
# ALWAYS PRINT TO THE CONSOLE FIRST
# ALWAYS STORE YOUR DATA IN TEMPORARY VARIABLES

# basic `stringr` commands... 

str_length(s1) 
# counts the number of characters matching arg

str_wrap(s3,1) 
# wraps inserts '\n' words specified position

str_wrap(s1,1)
# only works on strings with multple words

str_detect(s3,"a")
# returns TRUE if arg in element positon of argument

str_locate(s3,"a")
# returns positon of argument

str_replace(s3,"a"," (>*_*)> ")
# replaces arg1 with arg2

str_trim(s3)
# trims white space from edges " a " -> "a"

str_split(s3, " ")
#returns a list split by a pattern

str_sub(s1, -1, 3)
#subsets a string at start and end pos

# this one is tricky
?str_c #concatonate vector of strings
str_c(s1,s3, sep="%%")
str_c(s3, sep="%%") # sep only operates if more than on variable is passed to str_c
str_c(s3, collapse="%%") # colapses a vector into one string
# this is similar to paste()
str_c(s3, collapse="%%")


# the first argument in a stringr function is always a the string
# because of this `stringr` can be used with %>% pipes %>%
# pipes take the output of an function and pass it to the first argument of another 

# using %>% pipes %>%
str_trim(s3) %>% 
  str_split(" ") %>%
  unlist() %>%
  str_to_upper()

# `regex` ...
# use reference cards for regex help

# I use str_extract to test `regex`
str_extract_all(s2,"http[^[:space:]]*") %>% unlist()
findlinks <- function(x){
  str_extract_all(x,"http[^[:space:]]*") %>% unlist()
}
mylinks <- findlinks(s2)

# VI. Practical Application -----------------------------

# Programmatic data and file manimupation

# create tmp folder and set working directory
tmp<- paste0('tmp',Sys.Date())
dir.create(tmp)
setwd(tmp)

# this works in paste but no with str_c
#f <- str_c(rep('file',10),sample(1:10,replace=T),".tmp")
f <- paste0(rep('file',10),1:10,".tmp")
for (i in seq_along(f)) write_file("empty",f[i])
dir()

# write excel file 
require.pkgs('openxlsx')
Sys.setenv("R_ZIPCMD" = 'C:/RBuildTools/3.4/bin/zip.exe') 
# https://github.com/awalker89/openxlsx/issues/111
# set path to zip 
f <- paste0('tmp',1:10,'.xlsx')
# make fake dataset with links
mydata <- c(str_c("# ",s1),str_c(" asldkj ",mylinks," asldkj "))
for (i in seq_along(f)) write.xlsx(mydata,f[i],overwrite=TRUE) 
# if write.xlsx ERROR with zip see link above
# for (i in seq_along(f)){
#   . <- createWorkbook()
#   addWorksheet(.,sheet='sheet')
#   writeData(.,'sheet',s3) 
#   saveWorkbook(.,f[1],overwrite=TRUE)
# }
. <- str_extract(dir(),"^tmp.*")
f <- .[!is.na(.)]
s <- NULL*length(f) 
for (i in seq_along(f)){
  s <- capture.output(read.xlsx(f[i]))
  cat(i,'doing something something')
  mylinks == findlinks(s2)
}
dir()

#delete .tmp files
file.remove.warning(dir()) #warns before removing files
dir()

#step out of working directory and delete .tmp files  
# returns the parent of working directory
setwd(parent.dir())
getwd()


file.remove.warning(dir())
dir()
cat(dir())
unlink(dir())

