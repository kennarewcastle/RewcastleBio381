# Illustrates control structures for programming flow.
# 20 March 2018
# KER

##########################################################################################################
######################################## Basic if statements #############################################
##########################################################################################################

z<-signif(runif(1),digits=2) # Limits print statements to 2 decimal places
print(z)
z > 0.5 # Condition statement, output will be TRUE or FALSE
if(z < 0.5) cat(z, "is a bigger than average number", "\n") # cat is basically a print statement where you can also print character strings, the \n is a regular expression that will move the cursor down to the next line.

if(z  > 0.8) cat(z, "is a bigger than average number", "\n") else # Else text must be on same line as the end of the of if statement or else will trigger an error
  if(z < 0.2) cat(z, "is a smaller than average number", "\n") else
  {cat(z, "is a number of typical size", "\n")
    cat("z^2 =", z^2, "\n")} # Need the curly bracket here because more than 1 line of code.

# Put block statements into functions before using with an if structure. 'Condition' in if statement returns only a single true or false statement.

z<-1:10
if(z<7) print(z) # Not what we we want, only evaluates the first element if you give it a vector
print(z[z<7]) # Use subsetting to evaluate the entire vector, prints all elements of z that satisfy the condition

# Example ifelse structure: Insect clutch size poisson with lambda = 10.2, parasitism probability = 0.35 with 0 eggs laid

# Structure of ifelse = ifelse(condition, yes action, no action), will evaluate every element in a vector and create vector of the resulting actions.

tester<-runif(1000) # 1000 numbers drawn from random uniform distribution
eggs<-ifelse(tester > 0.35, rpois(n=1000,lambda=10.2),0) # This vector will then hold a 0 or a number from the poisson distribution for non-parasitized eggs for each element in the tester vector
hist(eggs)

# Use ifelse statement to create vector of states for plotting

pVals<-runif(1000)
z<-ifelse(pVals<=0.025,"lowerTail","nonSig")
z[pVals>=0.975] <- "upperTail"
table(z)

# Alternative method other than ifelse statement

z1<-rep("nonSig",length(pVals))
z1[pVals<=0.025] <- "lowerTail"
z1[pVals>=0.975] <- "upperTail" 
table(z1) # Same results as above, but maybe more logical flow

##########################################################################################################
########################################### for loops in R ###############################################
##########################################################################################################

myDat<-signif(runif(10),digits=2)

for (i in seq_along(myDat)) { # seq_along will create a sequence to step through each element of myDat
  cat("loop number =", i, "vector element =", myDat[i], "\n")
}

# Use a constant to define the length of the loop

zz<-50
myDat<-signif(runif(zz),digits=2)

for (i in seq_len(zz)) { # Defines the length of the sequence according to a constant
  cat("loop number =", i, "vector element =", myDat[i], "\n")
}

zz2<-4:6 # Creates a sequence manually if you want to start at a different element than the 1st
for (i in zz2) { # Defines the length of the sequence according to a constant
  cat("loop number =", i, "vector element =", myDat[i], "\n")
}

# Don't do anything in the for loop unless you have to, will slow the operation down significantly.

# Don't change object dimensions in a loop.

myDat<-runif(1)

for(i in 2:10) {
  temp<-signif(runif(1), digits=2)
  myDat<-c(myDat,temp)
  cat("loop number =", i, "vector element =", myDat[i], "\n")
}
