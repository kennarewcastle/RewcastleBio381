# Cluster Analysis
# April 25th, 2018
# KER

# Preliminaries
library(cluster)
library(factoextra)
library(ggplot2)
library(NbClust)

# Prepare data (scale so all parameters are given equal weight)
iris.scaled<-scale(iris[,-5])

# Step 1: Do clusters exist?
Hopkins <- get_clust_tendency(iris.scaled,n=nrow(iris.scaled)-1, seed=123)

Hopkins$hopkins_stat # Anything below 0.5 means that clusters do exist

# Step 2: Calculate Distance

distgower<-daisy(iris.scaled, metric="gower", stand=TRUE)

DistanceMap<-fviz_dist(dist.obj = distgower, show_labels = TRUE, lab_size = 4)
DistanceMap # Shows distance between individuals based on values for many different variables

# Step 3: Cluster using K-Means
set.seed(123)
km.res<-kmeans(iris.scaled,centers=6,iter.max=250,nstart=25) 
head(km.res)
# Assigns each individual to a cluster 1-6 based on the euclidean distance between that point and a randomly located centroid. Centroid location is moved each time so it is the average of all individuals in that cluster.

# What is the right number of clusters?

# Method 1: elbow method
fviz_nbclust(iris.scaled,FUNcluster=kmeans,method="wss") # Pick the number at the "elbow" of this graph where it tapers off (here, that would be 3)

# Method 2: silhouette method
fviz_nbclust(iris.scaled,kmeans,method="silhouette") + theme_classic() # Intersection of dotted lines and solid line is the optimal number of clusters

# Method 3: GAP STAT
fviz_nbclust(iris.scaled,kmeans,nstart=25,method="gap_stat",nboot=500)

# Method 4: Test All (runs all 30 possible tests to determine best number of clusters)
nb<-NbClust(iris.scaled,distance="euclidean",min.nc=2,max.nc=10,method="kmeans") # Output in console shows the number of clusters suggested by various tests, and the # of clusters proposed by majority

#### Validating Our Results
km.res<-eclust(iris.scaled,stand=FALSE,"kmeans",hc_metric="manhattan",k=3)
fviz_silhouette(km.res,palette="jco")

#### Approach 2: Hierarchical Cluster
# Algorithm will consider each individual its own cluster, then merges clusters based on distance

res.agnes<-agnes(x= distgower, diss=TRUE, stand=TRUE, metric="euclidean", method="ward")
fviz_dend(res.agnes,cex=0.6) # Relies on package robustbase, which isn't installing
fviz_dend(res.agnes,cex=0.6,k=2,rect=TRUE)

# Visualizing Dendrograms
fviz_dend(res.agnes,k=2,k_color="jco", type="phylogenic",repel=TRUE,phylo_layout="layout.gem") # SUCH A COOL VISUALIZATION

# Calculate P-values
library (pvclust)
data("lung")
ss<-sample(1:73,30)
newdata<-lung[,ss]
res.pv<-pvclust(newdata,method.hclust="average",method.dist="correlation",nboot=300)
plot(res.pv)
