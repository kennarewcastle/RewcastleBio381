# dplyr demo
# Brittany Verrico
# 1 May 2018
# KER

# If you load both plyr and dplyr and get errors as a result, specify that you want the function from a specific package using dplyr:: before the function call.

# Preliminaries
library(dplyr)
library(TeachingDemos)
char2seed("Aunt Marge")

# Call in data
HarryPotter<-read.csv("R_Package_Demos/HarryPotter.csv")
head(HarryPotter)

# Take a quick look at the structure
glimpse(HarryPotter) # similar to the str() function in base R

# Subset observations (rows) -- filter() function returns rows that satisfy 1 or many conditions
# Filter the rows for the Weasley family
output<-HarryPotter %>%
  filter(Last.Name=="Weasley")

print(output)

# Filter the rows for the Weasley family, and keep members that were born after 1980
HarryPotter %>%
  filter(Last.Name=="Weasley",BirthYear >= 1980)

# Random sample/selection of rows
# sample_frac()--samples a fracrtion of the data set (ex. 10%)
sample_frac(HarryPotter, size=0.1, replace=FALSE) # Samples 10% of datset

# sample_n()--similar to sample() function in base R
output<-HarryPotter %>%
  filter(Blood_Status=="HalfBlood",Sex=="Female")
print(output)

sample_n(output, size=2, replace=FALSE)

# Re-order rows the rows using function called arrange
output<-HarryPotter %>% 
  filter(Blood_Status=="PureBlood", Sex=="Male") %>%
  arrange(Last.Name,First.Name) # Orders by last name, then first name
print(output)

# Subset variables (columns)
output<-HarryPotter %>%
  select(First.Name,House)
print(output)

# Pipe to a base R function
HarryPotter %>%
  select(First.Name,House) %>%
  head

# Select all columns except for a specific column
HarryPotter %>%
  select(-Sex) %>% # Everyone column except for sex
  head(8)

# Select a range of columns
HarryPotter %>%
  select(Last.Name:House) %>% # Everyone column except for sex
  head

# Select helper functions
# Select columns sharing similar names using ends_with()
HarryPotter %>%
  select(ends_with("Name")) %>% # Pulls put all columns whose label ends with "Name"
  head

# Subset using regular expressions to pick out similar observations/columns
HarryPotter %>%
  select(matches("\\.")) %>%
  head

# Create a new variable/column
# Mutate and transmute
# Add a new column called "Name"
# First and last name combines"
# Add a new column called "Age"... Requires basic arithmetic, 2018-BirthYear
output<-HarryPotter %>%
  mutate(Name=paste(First.Name,"_",Last.Name),Age=(2018-BirthYear))
print(output)

# Add a new column called "Name", replace everything else
names<-HarryPotter %>%
  transmute(Name=paste(First.Name,"_",Last.Name))
head(names) # Just one name column now

# Summarize the data
# summarize() creates summary stat for a given column or columns in  a data frame
# group_by() groups/splits the data

# Split the data by house, take the average height of people in those houses, find the max height, find the total number of observations (# of people) for a particular house
HarryPotter %>%
  group_by(House)
summarise(avg_height=mean(Height), tallest=max(Height), total_ppl=n())

# Combine row and column functions within the same call
HarryPotter %>%
  select(Sex, Blood_Status, Height) %>%
  filter(Sex=="Male",Blood_Status=="PureBlood") %>%
  filter(Height > 67, Height < 72) %>%
  arrange(desc(Height))

# Instead of using OR (the | symbol), you can specificy a vector of options
HarryPotter %>%
  filter(House==c("Hufflepuff", "Ravenclaw"))
