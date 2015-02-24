library(tm)
library(SnowballC)
library(qdapDictionaries)
library(dplyr)
library(RColorBrewer)
library(ggplot2)
library(scales)

# Not all these packages are being used yet. This assumes you have a folder called 'text' in your directory.

#############################

# Script for text similarity


# This will compare *two* entire documents after cleaning them. 
#What needs to be added is the randomization part, whereby slices are taken and analysed separately. 
#This, however, shouldn't take long to implement. 
#The next steps, as I mentioned today, could be adding complementary metrics into the script, so we'd have several functions to measure the dimensions of text similarity. Finally, a summary could be built. The essential part is as follows.

################################

setwd('')

#there are different options for preparing the corpuses.
#Option 1 = scaling, which sums rows and divides by the scaling value
#Option 2 = not-scaling -- when document lengths are all the same.

#options(mc.cores=1) #sometimes this is necesssary

#load corpus
corpus <- VCorpus(DirSource("texts"), readerControl=list(language="English"))
#clean corpus
corpus <- tm_map(corpus, content_transformer(stripWhitespace))
corpus <- tm_map(corpus, content_transformer(tolower))
corpus <- tm_map(corpus, content_transformer(removePunctuation))
corpus <- tm_map(corpus, content_transformer(removeNumbers))

#mget scaling value (before removing stopwords)
corpus.dtm<-DocumentTermMatrix(corpus, control=list(wordLengths=c(1,Inf)))
corpus.matrix<-as.matrix(corpus.dtm, stringsAsFactors=F)
scaling<-rowSums(corpus.matrix)

#remove stopwords
corpus <- tm_map(corpus, removeWords, stopwords("English"))
#stem your documents
corpus <- tm_map(corpus, stemDocument, language = "english")

#remake dtm without stopwords
corpus.dtm<-DocumentTermMatrix(corpus)
corpus.matrix<-as.matrix(corpus.dtm, stringsAsFactors=F)
#remove sparse words
corpus.sparse.dtm<-removeSparseTerms(corpus.dtm, .4)
corpus.sparse.matrix<-as.matrix(corpus.sparse.dtm, stringsAsFactors=F)
#scale
corpus.scaled<-corpus.matrix
corpus.scaled[,1:ncol(corpus.matrix)]<- corpus.matrix[,1:ncol(corpus.matrix)]/scaling
#corpus.scaled<-corpus.sparse.matrix
#corpus.scaled[,1:ncol(corpus.sparse.matrix)]<- corpus.sparse.matrix[,1:ncol(corpus.sparse.matrix)]/scaling


# From this point, randomization can be accomplished with different samplings. One way to do this is first clean everything in the folder, and then start the analysis. Alternatively, the cleaning would be part of the process of each iteration (I'd go with the former option, though).


## MAKE FREQ LISTS FOR CORPORA



similarity = function(x,y){

options(warn=-1)

## CORPUS 1


corpus1 = unlist(corpus[[x]])

corpus1 = strsplit(corpus1, ' ')


corpus1Freq = data.frame(termFreq(corpus[[x]]))

corpus1Freq['word'] = rownames(corpus1Freq)

names(corpus1Freq) = c('obs', 'word')
row.names(corpus1Freq) = NULL

corpus1Freq = corpus1Freq[with(corpus1Freq, order(-obs)),]





## CORPUS 2

corpus2 = unlist(corpus[[y]])

corpus2 = strsplit(corpus2, ' ')

length(corpus2)


corpus2Freq = data.frame(termFreq(corpus[[y]]))

corpus2Freq['word'] = rownames(corpus2Freq)

names(corpus2Freq) = c('obs', 'word')
row.names(corpus2Freq) = NULL

corpus2Freq = corpus2Freq[with(corpus2Freq, order(-obs)),]




## COMPARISON BETWEEN CORPORA

corpora = data.frame(word=intersect(corpus1Freq$word, corpus2Freq$word), obs1=NA, obs2=NA)


corpora = corpora[100:1100,]

# edge1 = sample((round(nrow(corpora)/2)):nrow(corpora),1000)
# edge2 = sample(1:(nrow(corpora)/2),1000)

# start = c()
# finish = c()

# for(i in 1:length(edge1)){
	# if(edge2[i] - edge1[i] >= 1000){
		# start[length(start)+1] = edge1[i]
		# finish[length(finish)+1] = edge2[i]
	# }
# }

# start[length(start)+1] = 'hey'

# edge2[3] - edge1[3] >= 1000

# corpora[]



# Obs1 column

for(i in 1:nrow(corpora)){
  temp = subset(corpus1Freq, corpus1Freq$word == corpora[i,1])
  corpora[i,2] = temp[1,1]}


# Obs2 column

for(i in 1:nrow(corpora)){
  temp = subset(corpus2Freq, corpus2Freq$word == corpora[i,1])
  corpora[i,3] = temp[1,1]}


x = corpora$obs1
y = corpora$obs2



Chi2 = chisq.test(as.table(rbind(x,y)))[1][[1]][[1]]
pValue = chisq.test(as.table(rbind(x,y)))[3][[1]]


output = data.frame(Chi2, pValue)

return(output)
}

