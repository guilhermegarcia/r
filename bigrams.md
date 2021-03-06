# Bigram probability for segments

*Guilherme D. Garcia (Ball State University)*

The function below, ```biGram()```, calculates the bigram probability for any given word based on a given corpus. The output is logarithmic sum of the individual probabilities for each segmental bigram. The function requires two arguments, namely, a word (```x```) and a corpus/list of words. 


```{r}


biGram = function(x, corpus){

words = corpus

# Splitting input

x1 = strsplit(as.character(x), split="")[[1]]

# Storing bigrams

bigrams = c()

# Adding word-initial bigram

bigrams[1] = paste("^", x1[1], sep = "")

# Adding word-internal bigrams

for(i in 1:(length(x1)-1)){
	seq = paste(x1[i], x1[i+1], sep="")
	bigrams[length(bigrams)+1] = seq
}

# Adding word-final bigram

bigrams[length(bigrams)+1] = paste(x1[length(x1)], "$", sep = "")


# Variable for all probabilities

probs = c()

for(bigram in bigrams){
	probs[length(probs)+1] = length(grep(bigram, words)) / length(grep(strsplit(bigram, split="")[[1]][1], words))
}

return(log(prod(probs)))

}
```
