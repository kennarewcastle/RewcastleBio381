# Basic R commands and usage
# 30 January 2018
# KER

## Using the assignment operator
x<-5 # preferred assignment syntax
print(x)
# command + shift + return will run the whole script at once.
y = 4 # legal but not used excet in function 

plantHeight<-5.5

# Relational operators -- all return a boolean statement (true or false)

3 < 4
3 > 5:7 # will return a vector of T or F statements
3 >= 3 # greater than or equal to
3 == 4 # == means "is equal to"
3 != 4 # three "is not equal to" 4

# Set operators -- will operate on groups of vector, will compare two atomic vectors and return one atomic vector; will always strip out duplicate elements before the comparison.

i<-c(1,1:7)
print(i) # duplicates the number 1, will be stripped out before comparison

j<-3:10
print(j)

union(i,j) # all elements, strips out duplicated 1 
intersect(i,j) # common elements
setdiff(i,j) # unique elements of i that are not in j 
setdiff(j,i) # unique elements of j that are not in i (THIS AND PRECEEDING FUNCTION ARE NOT THE SAME)

# Set operators that return a single boolean statement after inputting two vectors

setequal(i,j) # comparison of the two vectors--are they the same?
setequal(i,i)
is.element(i,j) # sees if each individual element in i is in j at all
i %in% j # does the same thing as above

# Logical operators
z<-10:20
z<15 # inspects each element in z, compares it to 15, returns true or false statement
z < 20 & z > 17 # use the & symbol to make compound conditions (AND operator)
z < 20 | z >17 # use the | symbol as an OR operator

