# More basic coding tools for matrices and lists 
# 8 February 2018
# KER

library(ggplot2)

# Create a matrix from an atomic vector

m<-matrix(data=1:12,nrow=4) # matrix function requires at least an atomic vector and the number of rows OR the number of columnds
print(m) # default is to drop numbers in down one column, then the next

m<-matrix(data=1:12,nrow=4,byrow=TRUE) # this creates matrix by dropping numbers in across rows

dim(m) # returns the dimensions of the matrix, the first number is the number of rows, the second number is the number of columns

dim(m)<-c(6,2) # uses the dim function to assign/change the dimensions of a matrix (product of dimensions must equaL the length of the vector)

# If product of dimensions is LONGER than the atomic vector used to fill the matrix, the vector will start over to populate all places in the matrix.

nrow(m) # alternatives to using the dim function
ncol(m)
length(m) # returns the total length of the atomic vector (nrow x ncol)

# Add names to rows, columns
rownames(m)<-c("a","b","c","d")
colnames(m)<-LETTERS[1:ncol(m)] # Will name each column with capital letters, starting with "A", regardless of size of matrix
print(m)

# Subsetting matrix values
print(m[2,3]) # prints the value in row 2, column 3 using an index
print(m["b","C"]) # same thing, but uses the names of columns and rows to index to the correct element

print(m[2,]) # prints all elements in row 2 (conveniently lists column names as well)
print(m[,2]) # prints all elements in column 2 (also lists row names)
print(m[,]) # prints the whole matrix

print(m[c(1,4),c(1,3)])  # pulls out specific rows and columns from matrix, don't have to be contiguous

rownames(m)<-paste("Species",LETTERS[1:nrow(m)],sep="")
m      

colnames(m)<-paste("Site",1:ncol(m),sep="")
m

# Add names through the dim command with a list
dimnames(m)<-list(paste("Site",1:nrow(m),sep=""),paste("Species",ncol(m):1,sep="")) # assigns descending sequence for species number

# t function transposes matrices, makes rows become columns etc.
m<-t(m)
m

# Add a row to matrix with rbind
m2<-t(m)
m2<-rbind(m2,c(10,20,30,40))
rownames(m2)[4]<-"Species X"

# Can always convert this back to an atomic vector

myVec<-as.vector(m)
myVec
