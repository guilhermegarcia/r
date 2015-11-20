##### McGill University
##### R Tutorial
##### Guilherme D. Garcia

#############
### DAY 4 ###
#############

# FUNCTIONS and LOOPS

# What if you have a set of elements and you want to do something
# with each element?

ourSet = c(1,5,2,7,4,5,8,1,20,8,75,2,1,0)

for(number in ourSet){
	print(number*2)
}

# This very basic for loop is equivalent to

ourSet * 2






# It gets more interesting when what you need to do is less simple

for(number in ourSet){
	if(number < 5){
		print("Less than five.")
	} else{
		print("Greater than five.")
	}
}


# For loops are quite useful, but they can be too slow if you want
# to iterate over a gigantic corpus. In that case, {data.table} is better. We'll see a more interesting example later.


# Like any other language, we can create our own functions in R.

# Let's create a simple function.


greet = function(){
	print("Hello! Nice to meet you.")
}

# This function takes zero arguments, which means it's not that
# useful.

greet()

# Let's make it a little more useful by adding an argument.

greet = function(name){
	paste("Hi. My name is ", name, ". Nice to meet you!", sep = "")
}

greet("Bob")

# You can add as many arguments as you wish

greet = function(name, age){
	paste("Hi. My name is ", name, ". I am ", age, " years old.", sep = "")
}

greet("Bob", 19)

# Arguments are interpreted based on their position OR name:


greet(age=19, name="Bob")

# If you don't provide age, you get an error:

greet("Bob")

# Unless you add a default value for the variable (or set it as NULL)

greet = function(name, age=20){
	paste("Hi. My name is ", name, ". I am ", age, " years old.", sep = "")
}


greet("Bob")
greet("Bob", 12)




# Let's move on to string operations now, and then come back to fncs




# WORKING WITH STRINGS

# You can do MANY things with strings in R. The tm package 
# (TextMining) offers several useful tools (the same goes for
# languageR). Today, let's just focus on the basic tools, since
# this is a big topic.


# R already has a variable called "letters", which contains all letters

letters

# You can sample pseudorandom letters from there:

sample(letters, 5)

# Simple operations. Let's assume the following variable/string

x = "UniveRsity"

x

noquote(x) # This removes the ""


# Guess what each of the following functions does

nchar(x)
abbreviate(x, 5)
toupper(x)
tolower(x)
casefold(x, upper=TRUE)
chartr("university", "University", "McGill university")
chartr("uie", "@*%", "McGill University")
substr("university", 3, 7)
toString(19)

# Operationg on sets of strings

set1 = c('to have', 'to be', 'to go', 'to come', 'I am only in set1')
set2 = c('to go', 'to have', 'to forget', 'to climb', 'I am only in set2')

# Note the difference between the following two functions

nchar(set1)
length(set1)


union(set1, set2)

intersect(set1, set2)

setdiff(set1, set2)
setdiff(set2, set1)

setequal(set1, set2)
set1 %in% set2
set2 %in% set1

identical(set1, set2)

is.element("to go", set1)
"to go" %in% set1

sort(set1)

sort(sample(letters,10))

rep("x", 4)
paste(rep("x", 4), collapse=" ")



# Combining strings and variables (from fnc above)

paste("McGill is a", tolower(x), "in Montreal")






# Regular Expressions

# This is a huge topic, so google it to find more info on it. Regular
# expressions (aka REGEX) are extremely useful, mainly if you deal with
# strings

# Let's say we have a text (imagine this could be a corpus)

text = "Imagine you have a text with some emails, such as someone@mcgill.ca, or a particular structure you might be interested in. Perhaps you're interested in words containing -ing, and you'd like to extract these words (or maybe know the number of items with -ing). Regular expressions allow us to match string patterns, and this is very useful. The interesting part is that you can leave certain search parameters underspecified. Let's say you want to look for words that begin with any vowel, and then have a stop right after it. You can define groups of stops and refer back to them in your search."


# If you print it, you'll see this is a single string (a very long one)

text

# Let's separate all words and create a list.

words = strsplit(text, " ")

words

# Because this is using a space as criterion, periods, brackets etc.
# will be parsed as part of words.

# We can remove punctuation using different tools. This is the easiest:

library(tm)

removePunctuation(text)

words = strsplit(removePunctuation(text), " ")

words

# Note that it removes dashes and ' as well. We can use REGEX to solve
# that (see below).


# This will give us a list with ONE entry. Inside that entry, we have
# 103 items (words). This way, we can access specific words in text.

words


# Let's say your looking for a particular pattern: "ing"


# How many times does "ing" appear in words?


length(grep("ing", words[[1]]))

# What if you want "ing" OR "to"?

length(grep("ing|to", words[[1]]))

# Upper vs. lower case letters may give you different results:

length(grep("imagine", words[[1]]))

length(grep("Imagine", words[[1]]))

# Solution:

length(grep("[Ii]magine", words[[1]]))

# OR, in this case

length(grep("magine", words[[1]])) # !

# OR (this is better)

length(grep("imagine", words[[1]], ignore.case=T))

# Indices

grep("back", words[[1]])

# This is telling you that the word occupies position [98]
# in words[[1]]:

words[[1]][98]


# How many words start with a vowel...?

length(grep("^[aeiou]", words[[1]], ignore.case=T))

# How many words START with a stop?

length(grep("^[pbtdkgc]", words[[1]], ignore.case=T))

# How many words END with a stop?

length(grep("[pbtdkgc]$", words[[1]]))

# How many words start with a stop and are followed by a or o?
# (Of course, we're working with ORTHOGRAPHY here, so let's pretend
# that letters = sounds for now.

length(grep("^[pbtdkgc][ao]", words[[1]]))

# How about words begining with a stop and ending with a liquid?

length(grep("^[pbtdkgc]\\w+[rl]$", words[[1]]))

grep("^[pbtdkgc].*[rl]$", words[[1]])

words[[1]][14]

# . = any segment (including numbers!), except spaces and line breaks
# * = 0 or more of the previous element
# \\w = any letter

# etc.
# So, .* = anything, zero of more times

# IMPORTANT: 1 or more ->         +
		#    0 or more ->         *


# What if you actually want to EXTRACT some pattern from words?

# We already know how to do it. grep() gives us indices. So,
# we just need to use slide notation.

words[[1]][grep("^[pbtdkgc]\\w+[tp]$", words[[1]])]

# This looks kind of messy. Normally, it's a good thing to do it in
# steps.

# First, save the indices in a variable

goal = grep("^[pbtdkgc]\\w+[tp]$", words[[1]])

# Then, use the variable to extract the words

words[[1]][goal]

# "that" appears twice. We'd want to remove repeated words.

unique(words[[1]][goal])

# Now you can save that to a variable etc.


# ALTERNATIVELY, use regexpr():


x = regexpr("^[pbtdkgc]\\w+[tp]$", words[[1]])

regmatches(words[[1]], x)

# (Less intuitive, though)

# FUNCTIONS AGAIN

# EXERCISE: 

# Let's create a function that checks if a word is present in words

find = function(word){

	NULL
	
	
	}


# find("perhaps") should return "Found!"

###############################

# This is a more complex example. 
# Let's create a function that takes a word and returns CVs


profile = function(word){

    vowels = c("a", "e", "i", "o", "u")

    consonants = c("b", "c", "d", "f", "g", "h", "j", "k", "l", "m", "n", "p", "q", "r", "s", "t", "v", "x", "z", "Z", "N", "L", "w", "y")


    output = ""

    word = strsplit(word, "")

    for(letter in word[[1]]){
        if(letter %in% consonants){
            output = paste(output, "C", sep = "")}
        # else if(letter %in% glides){
            # output = paste(output, "G", sep = "")}
        else if(letter %in% vowels){
            output = paste(output, "V", sep = "")}
        else{
            if(letter == "'"){
                output = paste(output, "", sep = "")}
            if(letter == "-"){
                output = paste(output, ".", sep = "")}}
    }
    return(output)

}   

# Source: https://github.com/guilhermegarcia/r/blob/master/word_profiles.md



profile("horse") 

# Again: we're working with *orthography* here.

# You can modify the inventory of segments IN the function so that
# it fits the data you're working with.

# Let's combine these things now.



# CREATE A DATAFRAME WITH THE WORDS IN words

data = data.frame(words = words[[1]])

head(data)


# ADD A COLUMN THAT CALCULATES THE LENGTH OF EACH WORD

data$length = nchar(data$words)

# We got an error. How do you solve it? Make data$words a "character"

data$length = nchar(as.character(data$words))

# In fact, let's turn words into character (class)

data$words = as.character(data$words)

head(data)

# ADD A COLUMN WITH THE CV TEMPLATE (a little harder)

# To do this, we will use a for loop to apply the profile fnc to all
# rows.


# First, create a column and set it to NA

data$CV = NA

head(data)

# Now, this is what we do: for every word in data, run the profile
# function and assign its output to the CV column of the same row.

# Let's see what's going on here.

for(i in 1:nrow(data)){
	data[i,"CV"] = profile(tolower(data[i,"words"]))
}



head(data)

# Noticed that "you" was parsed as VV. 

# Remember we loaded the tm package? It already has a list of fnc wds:

stopwords()

# So we could add a new column: lexical vs. function words

data$type = ifelse(tolower(data$words) %in% stopwords(), "fnc", "lex")

head(data)

xtabs(~type, data)


# Regular expressions are very powerful, and there's a lot of 
# materials out there. Make sure to google it.







