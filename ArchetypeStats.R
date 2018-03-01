#### Data frame construction for logistic regression

xVar<-sort(rgamma(n=200,shape=5,scale=5)) # sort function reorders values from smallest to largest
yVar<-sample(rep(c(1,0),each=100),prob=seq_len(200)) # First entries in vectors have lowest probability of getting hit, last entries are highly likely to be selected

lRegData<-data.frame(ID=1:200,xVar,yVar) # Tuck a unique identifier into the dataframe

# Logistic regression analysis R

lRegModel<-glm(yVar~xVar,data=lRegData,family=binomial(link=logit))
summary(lRegModel)
summary(lRegModel)$coefficients # Quickly call out coefficients and p-values

# Basic ggplot for logistic regression

library(ggplot2) 

lRegPlot<-ggplot(data=lRegData,aes(x=xVar,y=yVar)) +
  geom_point() +
  stat_smooth(method=glm,method.args=list(family=binomial))

print(lRegPlot) # Basically shows a plot of probability of succeeding/failing given the value of X

### Basic contingency table analysis in R

vec1<-c(50,66,22)
vec2<-c(120,22,30)

# Create a matrix instead of a data frame because rows and columns are CATEGORIES, not observations
dataMatrix<-rbind(vec1,vec2)
rownames(dataMatrix)<-c("Cold","Warm")
colnames(dataMatrix)<-c("Aphaenogaster","Camponotus","Crematogaster")

# Null hypothesis for contingency table is that the relative proportion of columns across categories is random and not significantly different. Alternative hypothesis is that proportion of each category is significantly different.

print(chisq.test(dataMatrix))

# Plots for contingency tables are not yet available in ggplot

mosaicplot(x=dataMatrix,col=c("goldenrod","grey","black"),shade=FALSE) # Area of tiles is proportional to frequency counts in each of the six categories. 
           