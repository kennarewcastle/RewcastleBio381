# All about functions
# 1 March 2018
# Kenna Rewcastle

# In R, practically everything is a function

sum(3,2) # Formatted as a "prefix" function
3 + 2 # Also a function
`+`(3,2) # "infix" function

y<-3 # The "assignment function
`<-`(yy,3) # Same result as above
print(yy)

sum # Gives content of function and nothing else, print statement
sum (3,2) # function call with inputs
sum() # Uses default values

##### Creating Functions

# Calling 'return()' in the body of the function will print a specific vector or list and will kick you out of the function and print that value, even if there are still arguments left in the function. If interested in printing a statement in the middle of the function and still run the rest of the function, use PRINT statements!

# Style for functions:
  # Fence off function with prominent comments
  # Give header and description of function, input, output
  # Use simple names for function variables
  # Use no more then 1 screenful of code for each chunk of a function
  # Provide default variables for all parameters, useful for troubleshooting function
  # Use random number generators to create default parameters/variables

##### First function

#################################################################################################
# FUNCTION: HardyWeinberg
# Calculates Hardy Weinberg allele frequencies 
# input: allele frequency p (0,1)
# output: p and frequencies of AA, AB, BB genotypes
#-----------------------------------------------------

HardyWeinberg<-function(p=runif(1)) {
  q<-1-p
  fAA<-p^2 # frequency of AA
  fAB<-2*p*q # frequency of AB
  fBB<-q^2 # frequency of BB
  
  vecOut<-signif(c(p=p,AA=fAA,AB=fAB,BB=fBB),digits=3) # signif specifies number of decimal places desired
  return(vecOut)
}
##################################################################################################

HardyWeinberg()
HardyWeinberg(p=0.5)

#################################################################################################
# FUNCTION: HardyWeinberg2
# Calculates Hardy Weinberg allele frequencies 
# input: allele frequency p (0,1)
# output: p and frequencies of AA, AB, BB genotypes
#-----------------------------------------------------

HardyWeinberg2<-function(p=runif(1)) {
  if(p > 1.0 | p < 0.0) { # Boolean statement with '|' means OR
    return("Function fails, p out of bounds")
  }
    
  q<-1-p
  fAA<-p^2 # frequency of AA
  fAB<-2*p*q # frequency of AB
  fBB<-q^2 # frequency of BB
  
  vecOut<-signif(c(p=p,AA=fAA,AB=fAB,BB=fBB),digits=3) # signif specifies number of decimal places desired
  return(vecOut)
}
##################################################################################################

HardyWeinberg2()
HardyWeinberg2(p=1.1)
temp<-HardyWeinberg2(1.1) # Function still runs, temp now just contains a character string with the error

#################################################################################################
# FUNCTION: HardyWeinberg3
# Calculates Hardy Weinberg allele frequencies 
# input: allele frequency p (0,1)
# output: p and frequencies of AA, AB, BB genotypes
#-----------------------------------------------------

HardyWeinberg3<-function(p=runif(1)) {
  if(p > 1.0 | p < 0.0) { # Boolean statement with '|' means OR
    stop("Function fails, p out of bounds") # Causes function to fail without completing
  }
  
  q<-1-p
  fAA<-p^2 # frequency of AA
  fAB<-2*p*q # frequency of AB
  fBB<-q^2 # frequency of BB
  
  vecOut<-signif(c(p=p,AA=fAA,AB=fAB,BB=fBB),digits=3) # signif specifies number of decimal places desired
  return(vecOut)
}
##################################################################################################

temp1<-HardyWeinberg3(1.1) # Does not run function, produces error message that gives our stop error message.

#### Understanding scope of local and global variables

myFunc<-function(a=3,b=4){
  z<-a+b
  return(z)
}

myFunc()

myFuncBad<-function(a=3){
  z<-a+bbb
  return(z)
}

myFuncBad() # Fails because bbb can't be found locally within the function or globally as an object outside the function body.

bbb<-100
myFuncBad() # Works, but BAD coding style, never refer to things in global environment that are not declared as local objects through the function input.

####################################################################################################
# FUNCTION: fitLinear
# fits linear regression
# input: numeric vectors of x and y
# output: slope and p value
#----------------------------------------------
fitLinear<-function(x=runif(20),y=runif(20)){
  myMod<-lm(y~x) # fits model
  myOut<-c(slope=summary(myMod)$coefficients[2,1],pVal=summary(myMod)$coefficients[2,4])
  plotVar<-qplot(x=x,y=y)
  print(plotVar)
  return(myOut)
}
#####################################################################################################

fitLinear() # Output is a scatter plot, slope, and p-value

##### Dealing with too many parameters by bundling them up

z<-c(runif(99),NA)
mean(z) # Need to account for NA
mean(x=z,na.rm=TRUE) # One way to remove NAs
mean(x=z,na.rm=TRUE,trim=0.05) # Strips most extreme outliers off of data (retains 95% of values)
l<-list(x=z,na.rm=TRUE,trim=0.05)
do.call(mean,l) # Provide a function and the parameter list l to avoid having to type all of the parameters over and over again
