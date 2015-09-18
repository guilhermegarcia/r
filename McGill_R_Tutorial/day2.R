##### McGill University
##### R Tutorial
##### Guilherme D. Garcia

#############
### DAY 2 ###
#############


# Packages: This time, we'll use a couple of packages. 
# Normally, we load all packages together at the top of the script (for practical reasons only). 
# This way, it's easy to see where all packages are. Packages are like modules: each one is a collection of functions 
# (among other things) that we can use. In a way, loading a package is like adding functions to R (this makes R a 
# very powerful tool, since anyone can create a package). 
# Whenever you want to do something more specific, chances are there's a package for it.


library(plyr)
library(data.table)
library(languageR)

# Today, we'll load a data file and work with it (summarize the patterns in the data, add/manipulate columns etc.). 

# First, as usual, let's set our working directory. Let's make our Desktop our wd.

setwd("~/Desktop")

# But maybe you want to have a specific folder IN your desktop, something more 'organized'. 
# Let's create a new folder (directory) IN our desktop called 'Day2'. 
# Then, let's set our working directory again, as we'll be working inside 'Day2'.

dir.create("Day2")

# Now you can check it exists:

dir.exists("Day2")

setwd("~/Desktop/Day2")


# Of course, you can create a folder and set your dir manually, using your mouse. 
# But this might be easier/faster. Also, this is a useful way to automate folder creating in your script.


################################

################## 1. Loading files


# To load a TXT file:

data = read.table("file_name.txt")


# Alternatively, we can use read.csv, as long as we tell R that this is NOT actually csv file.


data = read.csv("file_name.txt", sep = "\t")

# These two commands are equivalent.

# And if you want to read a CSV file...

data = read.csv("file_name.csv")


# Even though we'll use data frames most of the time, *data tables* are WAY better (and faster). 
# Their syntax is a bit more intricate, but they're definitely better if you have a lot of data

# In fact, you can calculate how much time it takes to read a file (or do perform any other task) in R. 
# Let's test this loading the Buckeye Corpus:

system.time(rnorm(10000000))

# So it takes 8s (in my laptop) for R to generate 10 million numbers (which are normally distributed)

path = "path_to_file_here"

system.time(read.csv(path))

# Now, let's use data.table, a very powerful package

# And let's calculate it again:

system.time(fread(path))

# You can see fread() in {data.table} is WAY faster, and this makes a huge difference if you're loading large files.

# We won't be using data.table, but you should know about it—mainly if you work with corpora/large files.


# Now, we've loaded our data and the file is stored in a variable called 'data'. 
# Everything we do to this variable will NOT affect the original file. R loaded a 'copy' of tapped.txt, 
# and that's it. If you delete something by mistake, don't worry: the original will always be there as far as
# you do not export a new txt file and overwrite it (we exported a csv file last time).

# Again, if you want to export the file, you have different ways to do that. Here are two:

# !! R will NOT ask you if you're sure you want to overwrite a file when you export your data. So be careful.

write.csv(data, "~/Desktop/file_name.csv")

write.table(data, "~/Desktop/file_name.txt", sep="\t")



############################
############################
############################
############################
############################

# Today, we will actually use one of the datasets included in R. More specifically, 
# these data are in an R package called languageR—which, btw, is extremely useful for linguists, of course.



# To load a dataset that's already IN R:

data(dative) # Use the function data()

ls()

data = dative # let's rename it

head(data)

# What conditions dative alternation in English?



# NP: Mary gave [Peter] the ball

# PP: Mary gave the ball [to Peter]

# Recipient: Peter
# Theme: Ball


# This study aimed to investigate what conditions the realization of the recipient: PP or NP.


# To understand this dataset, 

?dative

# ? is used to get help on a function OR element in the R language. You can't use it for variables you created, 
# only for terms that have an intrinsic meaning in R (or in one of its packages).



# There are several columns, so let's work with a subset of columns as we don't have too much time.

names(data)

columns = c("Verb", "SemanticClass", "AnimacyOfRec", "PronomOfRec", "LengthOfTheme", "AnimacyOfTheme", "RealizationOfRecipient")


new = subset(data, select = columns)

# Alternatively,

new = data[,columns]


head(new)

# Let's say you don't like the names of the columns (they're long and not very consistent). We can change that:

names(new) = c("verb", "semClass", "animacyRec", "proRec", "lengthTheme", "animacyTheme", "realization")

head(new)

############# 2. Taking a look at your data


# Probably the first thing you want to do is look at the data to check if everything looks ok.

head(new) # By default, this will give you the first 6 rows of the data file. You can change that, though:

head(new, 10)


# You can also check the *last* rows in the data:

tail(new,10)

# What are the column names in the data?

names(new) # Column names

# This is particularly useful if you have a large dataset, since it's a very economical way of looking at 
# the variables in the file.


# If you want something a little more comprehensive:

summary(new)

# This will give you some basic stats as well as an overview of the dataset



# How many columns are there?

ncol(new)

# How many rows...?

nrow(new)


# What are the dimensions (rows by cols)

dim(new)


# Given the number of columns, when you visualize the data, the columns will break.


# If you recall, you can also use indices (slice notation) to take a look at the data. 
# Let's say you want to check the first 10 rows of the fourth column:

new[1:10,4] # This will also give you the levels of this factor (if the column is, in fact, a factor)

# Alternatively, if you don't know the number of a column:

new$semClass[1:10]

# This says: Inside data, select the column SemanticClass and give me the first 10 items. 
# Note that here you don't use a comma, since a single column only has one dimension.

# SEMANTIC CLASS CODES:  
# a (abstract: 'give it some thought'), 
# c (communication: 'tell, give me your name'), 
# f (future transfer of possession: 'owe, promise'), 
# p (prevention of possession: 'cost, deny'), and 
# t (transfer of possession: 'give an armband, send').




# Another important thing to do right after you load your data is check whether your variables are coded correctly. 
# R will assume numbers are numeric, but sometimes you want numbers to be a factor, for example. This will need to be corrected.


str(new)

# Things look ok. Note that this also tells you the number of levels in each factor.

# Alternatively,

levels(new$verb) # will give you the levels themselves

# And

length(levels(new$verb)) # will give you the number


# Let's take a look at the first rows again:




######### Cross-tabulation and proportions


# This is a *very* useful way of looking at your data. Even before we plot things, 
# it's nice to take a look at counts/% given certain variables, for example.

# Option 1: use xtabs()

# One dimension:

xtabs(~proRec, new)

xtabs(~animacyTheme, new)


# Two dimensions:

xtabs(~proRec + animacyTheme, new)


xtabs(~realization + semClass, new)

# SEMANTIC CLASS CODES: a factor with levels 

# a (abstract: 'give it some thought'), 
# c (communication: 'tell, give me your name'), 
# f (future transfer of possession: 'owe, promise'), 
# p (prevention of possession: 'cost, deny'), and 
# t (transfer of possession: 'give an armband, send').



# Three dimensions:

xtabs(~proRec + animacyTheme + semClass, new)

# Note that the order of the arguments does matter. The third argument here is the third dimension, 
# so it's best to pick a factor that has fewer levels.

xtabs(~semClass + animacyTheme + proRec, new)



# ALTERNATIVELY, use table():

table(new$proRec, new$animacyTheme)

# What if we want to see %s?

# In this case, we use prop.table() in addition to xtabs():

prop.table(xtabs(~proRec, new)) # * 100 if you wish

# However, when there are more than 1 dimension, there are different ways % can be calculated: ALL, ROW or COLUMN.

prop.table(xtabs(~realization + semClass, new))

# You can see that the default is to calculate %s over *all* cells, which isn't that useful here. 
# We can solve that: For rows, use 1; for cols, use 2.

prop.table(xtabs(~realization + semClass, new),1)


prop.table(xtabs(~realization + semClass, new),2)

# So we can see that verbs like cost and deny ('prevention of possession' favour NP over PP in almost all cases) 


# We'll see plots next time, but you can easily plot this:

# Let's see if 


counts = table(new$proRec, new$realization) 

plot(counts)

barplot(counts)

# Now with some important details

barplot(counts, legend.text = TRUE, args.legend = list(x = "topright"), main = "Pronominal vs. Non-pronominal recipients")

# By saying legend.text = TRUE, we're telling R to add a legend to the plot. This is automatically set, 
# given the structure of counts. However, you might want to add different labels:

barplot(counts, legend.text = c("Non-pronominal", "Pronominal"), args.legend = list(x = "topright"), main = "Pronominal vs. Non-pronominal recipients")

# Let's save this plot. There are two ways of doing that:

# Easy: just press cmd + s when the plot window is selected.

# Less easy: surround your plot with these two lines.

# pdf("plot.pdf")


# dev.off()


# FOR EXAMPLE:

pdf("plot.pdf")

barplot(counts, legend.text = c("Non-pronominal", "Pronominal"), args.legend = list(x = "topright"), main = "Pronominal vs. Non-pronominal recipients")

dev.off()

# This opens a file, "prints" the plot, and closes the file. You *have to* close it (dev.off()).









# These results make sense.




head(new)


######### Summarizing your data


# Let's say you want to know the average length of theme by RealizationOfRecipient. 
# Perhaps the longer the theme, the more likely it is to realize the recipient as an NP:

# Give the interesting text to Bob

# Give Bob the interesting text 

summ1 = ddply(new,. (realization), summarise, meanLength = mean(lengthTheme))

summ1


# Ok, you could in principle get both means manually:

mean(new[new$realization == "NP",]$lengthTheme)
mean(new[new$realization == "PP",]$lengthTheme)

# This combines slice notation AND the $ sign, and creates a big argument for mean. Make sure you understand the syntax here.

# However, things start to get too time-consuming very quickly:

summ1 = ddply(new,. (realization, semClass), summarise, meanLength = mean(lengthTheme))

summ1

# In this case, we would need 10 lines to do it manually the way we did above.

# Let's say you want to save this table/data frame. 

write.csv(summ1, "summary.csv", row.names=F)


# Great. What if we want to know the standard deviation as well...? Perhaps NP and PP have a high sd.

summ1b = ddply(new,. (realization), summarise, meanLength = mean(lengthTheme), sdLength = sd(lengthTheme))

summ1b




######################################
######################################
######################################



# EXERCISE

# 1. Create a data frame that contains only data for the verb give. Assign it to variable called "give". 
# How many rows does the data frame have?

give = new[new$verb == "give",]

cat("There are", nrow(give), "rows")

# 2. Summarize that data frame using ddply, adding a column for mean LengthOfTheme. Assign the output to a 
# variable giveSum. You should keep the following columns: animacyRec, realization and semClass. 
# The new column should be called meanLength. Now look at the rows: which case has the largest meanLength of theme?

giveSum = ddply(give,.(animacyRec, realization, semClass), summarise, meanLength = mean(lengthTheme))

# The highest mean is 5.84: animacyRec = animate, realization = NP, semClass = a.

# 3. What % of cases in give are realized with NP? And PP? Add a second dimension (proRec). 
# Now only look at pronominal cases. What's the % of realization = NP?

prop.table(xtabs(~realization, give))

# 84.6% of the cases are realized as NP; 15.4% as PP.

prop.table(xtabs(~realization + proRec, give),2)

# 92.9% = NP (among pronominal)




# 4. Finally, does the animacy of the recipient have an apparent effect on its realization in give?

prop.table(xtabs(~realization + animacyRec, give),2)

# Apparently, no.


































# If you're taking Methods, these are the answers to the practice problem (Homework 0)

# Questions from Methods (HW0)

# Q1

data = read.csv("read_tapped_data")

df = data

df$ZeroPause = ifelse(df$pause == 0, "True", "False")

df$ZeroPause = as.factor(df$ZeroPause)

head(df)


# Q2

sum(df$syntax == "intransitive" & df$tapped == "Tapped", na.rm=T)


# Q3

sum(df$speechrate == "fast" & !df$participant %in% c("1278", "1284", "1296"))

# Q4

prop.table(xtabs(~tapped, df[df$participant == "435",]))

#### OR

sum(df$participant == "435" & df$tapped == "Tapped") / sum(df$participant == "435")


# Q5

p = sum(df$tapped == "Tapped", na.rm=T) / length(df$tapped)



# Q6

result = rbinom(1000,10,p)




pdf("plot.pdf")
hist(result)
dev.off()

# Of course, you can always simply press cmd + s to save your plot...
