### Text similarity

This is ongoing work on text similarity, using the ```tm``` package and implementing chi-square test as suggested in Kilgarriff (2001).


```{r}

library(tm)
library(SnowballC)
library(qdapDictionaries)
library(dplyr)
library(RColorBrewer)
library(ggplot2)
library(scales)

# Not all these packages are being used yet.

#############################

# Script for text similarity


# This will compare *two* entire documents after cleaning them. What needs to be added is the randomization part, whereby slices are taken and analysed separately. This, however, shouldn't take long to implement. The next steps, as I mentioned today, could be adding complementary metrics into the script, so we'd have several functions to measure the dimensions of text similarity. Finally, a summary could be built. The essential part is as follows.

################################

setwd('~/Desktop')


# source is any folder with a given number of docs

source = DirSource('texts/')
corpus = Corpus(source, readerControl = list(reader=readPlain))

corpus = tm_map(corpus, content_transformer(tolower))

corpus = tm_map(corpus, removeWords, stopwords("english"))

# Stemming corpora + removing white space

corpus = tm_map(corpus, stemDocument)

corpus = tm_map(corpus, stripWhitespace)

# Punctuation



corpus[[1]] = removePunctuation(corpus[[1]])
corpus[[2]] = removePunctuation(corpus[[2]])

dtm = DocumentTermMatrix(corpus)

dtm = removeSparseTerms(dtm, 0.4)

# From this point, randomization can be accomplished with different samplings. One way to do this is first clean everything in the folder, and then start the analysis. Alternatively, the cleaning would be part of the process of each iteration (I'd go with the former option, though).


## MAKE FREQ LISTS FOR CORPORA


## CORPUS 1

corpus1 = unlist(corpus[[1]])

corpus1 = strsplit(corpus1, ' ')

length(corpus1)


corpus1Freq = data.frame(termFreq(corpus[[1]]))

corpus1Freq['word'] = rownames(corpus1Freq)

names(corpus1Freq) = c('obs', 'word')
row.names(corpus1Freq) = NULL

corpus1Freq = corpus1Freq[with(corpus1Freq, order(-obs)),]

head(corpus1Freq)



## CORPUS 2

corpus2 = unlist(corpus[[2]])

corpus2 = strsplit(corpus2, ' ')

length(corpus2)


corpus2Freq = data.frame(termFreq(corpus[[2]]))

corpus2Freq['word'] = rownames(corpus2Freq)

names(corpus2Freq) = c('obs', 'word')
row.names(corpus2Freq) = NULL

corpus2Freq = corpus2Freq[with(corpus2Freq, order(-obs)),]



head(corpus2Freq)






## COMPARISON BETWEEN CORPORA

corpora = data.frame(word=intersect(corpus1Freq$word, corpus2Freq$word), obs1=NA, obs2=NA)

head(corpora)

# Obs1 column

for(i in 1:nrow(corpora)){
temp = subset(corpus1Freq, corpus1Freq$word == corpora[i,1])
corpora[i,2] = temp[1,1]}


# Obs2 column

for(i in 1:nrow(corpora)){
temp = subset(corpus2Freq, corpus2Freq$word == corpora[i,1])
corpora[i,3] = temp[1,1]}


###############


corpora['exp1'] = NA
corpora['exp2'] = NA



# Calculating expected values for each word

N1 = nrow(corpus1Freq)
N2 = nrow(corpus2Freq)


for(i in 1:nrow(corpora)){
	corpora[i,4] = (N1 * (corpora[i,2] + corpora[i,3]))/(N1 + N2)
}

for(i in 1:nrow(corpora)){
	corpora[i,5] = (N2 * (corpora[i,2] + corpora[i,3]))/(N1 + N2)
}

# exp1 = (N1 * (O1 + O2))/(N1 + N2)
# exp2 = (N2 * (O1 + O2))/(N1 + N2)


# Creating other columns for chi

corpora['chi1'] = ((corpora$obs1 - corpora$exp1)^2)/corpora$exp1
corpora['chi2'] = ((corpora$obs2 - corpora$exp2)^2)/corpora$exp2

# corpora['EXP'] = corpora$exp1 + corpora$exp2
# corpora['OBS'] = corpora$obs1 + corpora$obs2

head(corpora,10)



# Summary

# sum(corpora$chi1)
# sum(corpora$chi2)

# var(corpora$chi1)
# var(corpora$chi2)

# mean(corpora$chi1)
# mean(corpora$chi2)

# sd(corpora$chi1)
# sd(corpora$chi2)

chisq.test(corpora$obs1, corpora$obs2)

chisq.test(corpora$chi1, corpora$chi2)


################################






```
