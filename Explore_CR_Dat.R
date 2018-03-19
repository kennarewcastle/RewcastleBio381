#### Playing with d13 CO2 data from Costa Rica
library(dplyr)
dat<-read.csv("Costa Rica Master sheet annotated.csv")
dat<-filter(dat,Exclusion!="NA")

Sdat<-filter(dat,Isotope_label=="S")
Sdat<-filter(Sdat,d13_d5!="NA")
d135<-Sdat$d13_d5
mean(d135)

Ldat<-filter(dat,Isotope_label=="L")
Ldat<-filter(Ldat,d13_d9!="NA")
d139<-Ldat$d13_d9
mean(d139)

datS<-dat[dat$Isotope_label=="S",]
datS1<-datS[datS$Exclusion==1,]
datS2<-datS[datS$Exclusion==2,]
datS3<-datS[datS$Exclusion==3,]

datL<-dat[dat$Isotope_label=="S",]
datL1<-datL[datL$Exclusion==1,]
datL2<-datL[datL$Exclusion==2,]
datL3<-datL[datL$Exclusion==3,]

