##### McGill University
##### R Tutorial
##### Guilherme D. Garcia

#############
### DAY 1 ###
#############





## WELCOME ##

################################################

# To run a line, press cmd + enter (or ctrl + enter)

# To run the whole file, press cmd + e (more on this later)

################################################


# First, it's important to know WHERE we're working: our working directory (i.e., the folder R takes as default)


getwd() # To know what your wd is. You can also go to MISC in the menu.


setwd() # To set another folder as your wd. Alternatively, press cmd + D

setwd("~/Desktop/test")




# ===================== 1. CALCULATOR

# First and foremost, R can be used as a (powerful) calculator:

seq(100)

3 + 4

5 - 2

10 / 3

2 ** 3 # or 2 ^ 3

10 %% 3

sqrt(10)

log10(100)

3**2 - (3 - 4 / (3 + 1)) * sqrt(148 %% 32)


################################################



# ===================== 2. VARIABLES


# You can assign values to variables. Your variable name can be (almost) anything---it can't start with a number, though.

myVariable = 5
myVariable <- 5
5 -> myVariable

# camelCase is quite useful to separate words, as spaces are not allowed. Alternatively, my_variable or my.variable (not ideal).

# If you now run myVariable, you'll get 5. If you want to check all the variable assingments in your workspace, use ls():

ls()

# To CLEAN your workspace:

rm(list = ls())


# What if you want to have several values assigned to a single variable?

x = c(1,2,3,4,5,6,7)



################################################



# ===================== 3. CLASSES


#............ NUMBERS: what we did above



#............ STRINGS: text

x = "This is a string. You need quotation marks to make strings."

# If you don't use quotation marks, R will think your word is a variable. You can either you single or double marks. 
# Double are better, since you may have contractions in English. Just be consistent.




#............ BOOLEAN: True or False

y = FALSE # or F (all capitals)

z = TRUE # or T



#............ VECTORS: a SEQUENCE of values of the SAME class

# Vectors take numbers, booleans, strings... but you can't mix them up.

x = c(1,2,3,4,5)

x = seq(from=1, to=5)

y = c("Canada", "UK", "Australia", 2)

x

y

x

# Note that the 2 in the vector was coerced into string

# You can give names to each item:

names(x) = c('One', 'Three', 'Two', 'Four', 'Five')

x

# Now, you can access specific items with the slice notation

x["One"]

y[3]

# In a way, this is kind of like dictionaries in Python





#............... LISTS: a SEQUENCE of values that may have != classes

# What if you want to have numbers, booleans and strings in a sequence?


myList = list(1,2,3,4,"Mexico", TRUE)

myList

# You can check the length of the list:

length(myList)


# How to access different terms in a list?


myList[[6]]







# ???????????????????????? EXERCISE

# Assume the following list:

universities = list("McGill", "Concordia", "UdeM", "UQAM", list("UofT", "Waterloo", "UBC", "Calgary"))

# First, print the list and examine its items.





# Q: HOW DO YOU ACCESS/print "Calgary"?




universities[[5]][[4]]

# ????????????????????????











#### CHECKING CLASSES

class("Hey")
class(4)
class(myList)
class(FALSE)



# In fact, you can check truth values as well

5 > 3

3 == 2			# Note that == is not the same as =

2 != 9			# Is 2 different from 9?

myList

"Mexico" %in% myList		# Is "Mexico" in myList?

# The command %in% is extremely useful, as we'll see later



# ===================== 4. DATA FRAMES


# Data frames basically "data". This is basically your 'Excel spreadsheet', except that in R you won't be looking at 
# it all the time (that wouldn't be very useful anyway).

# R can read several kinds of files, but we will be using CSV, since this is the most common 
# type in Linguistics (XML and TXT are also quite common). Avoid using XLS. Unless you're working with 
# big data, csv and txt are totally fine (XML is great for corpora, for example).

# For now, let's not load data yet. Instead, let's create a table from scratch. 
# You will not do this very often, but by doing this you'll learn how to do things that you will be doing a lot.


# First, let's create a vector of countries. Then, another vector with capital cities.

# This is what we do: first, we create the material that will go in the table. Then, we merge things into a table. See below.

countries = c("Argentina", "Germany", "Spain", "Russia", "Japan")


capitals = c("Buenos Aires", "Berlin", "Madrid", "Moscow", "Tokyo")

countries
capitals

# Imagine these two vectors are our future columns. Now, let's create our data frame, using the function data.frame(). 
# This will 'glue' our columns (vectors above) together.

myData = data.frame(Country = countries, Capital = capitals) 

# OR

myData = data.frame(countries, capitals) # In this case, the column names will match the vector names

myData

# OK, now we have a spreadsheet---a data frame. You could export this as a CSV file:




write.csv(myData, "myFirstDataFrame.csv", row.names = F) # CSV

write.table(myData, "file_name.txt", sep="\t") # Tab-delimited txt file

# EVEN Excel and SPSS:

library(xlsx) # You need this package for R to 'interact' with Excel files
write.xlsx(mydata, "file_name.xlsx")

library(foreign)
write.foreign(myData, "file_name.txt", "file_name.sps",   package="SPSS")

getwd()

# This will save the file in your working directory. You can ask R what it is:

getwd()

# You can also set a different dir:

setwd("~\Desktop")


########################


# What if you want to add a new column? Let's create a different one with the approx. population of each country in millions


population = c(40, 80, 50, 140, 130)

# Again, we can start by creating a vector

# Now, let's add it to our data frame

myData$Population = population

myData["Population"] = population


myData

# a$b basically means column b inside a. In other words, inside myData, create Population, 
# which will be = to our variable population above


myData

######################


# Let's now create a nother column called "Big". This will be "Yes" if the country has more than 100 million 
# inhabitants, and "No" otherwise. We'll do that using a very intuitive function: ifelse()



myData$Big = ifelse(myData$Population > 100, "Yes", "No")

myData

# Note that ifelse() requires three arguments: condition, what to do if condition = True, and what to do elsewhere.

myData


# We'll get more into this next time.




# ??????????????????? EXERCISE


# Create the following data frame:

# It contains some languages, one country, continent, and number of native speakers in millions

# Language		Country		Continent		nSpeakers
# Chinese		China		Asia			1197
# Spanish		Spain		Europe			414
# English		UK			Europe			335
# Hindi			India		Asia			260
# Navajo		USA			NAmerica		0.17


# Then, create a new column called "WhoSpeakIt", which should be:

# "Many" if there are more than 400 million speakers; "Some" if there are more than 100 million speakers; 
# and "Few" if there are fewer than 1 million speakers.

# Hint: You can do this in 6 steps.

# Answer:

language = c("Chinese", "Spanish", "English", "Hindi", "Navajo")

country = c("China", "Spain", "UK", "India", "USA")

continent = c("Asia", "Europe", "Europe", "Asia", "NAmerica")

nSpeakers = c(1197, 414, 335, 260, 0.17)


test = data.frame(Language = language, Country = country, Continent = continent, nSpeakers = nSpeakers)


test$WhoSpeakIt = ifelse(test$nSpeakers > 400, "Many", ifelse(test$nSpeakers > 100, "Some", "Few"))

test

popular = subset(test, WhoSpeakIt != "Few")
popular = subset(test, WhoSpeakIt %in% c("Many", "Some"))

popular = test[test$WhoSpeakIt != "Few",]

popular


test[,2]

popular = subset(test, nSpeakers > 100)

popular

