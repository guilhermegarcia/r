# Phonotactic distribution

*Guilherme D. Garcia*

Assume you have a string of segments ```str``` in a given language. This script contains a function ```seg()``` that takes
```str``` as its only argument and returns a data frame with the segments that follow ```str``` in the language in question.
Segments are sorted in decreasing order of frequency.

### How to use it

The script is based on the Portuguese Stress Corpus. 
However, you can use any corpus and simply adapt the script. The Portuguese corpus in question contains a column for
pronunciation which uses a SAMPA-like transcription. The input of ```seg()``` necessarily needs to conform to whichever
transcription system you have in your own corpus.

### Example

Let's take the sequence ```kame``` in Portuguese (the function already loads all the necessary packages). Given that sequence,
what are the possible following segments—and which one is more frequent in the whole lexicon?

```{r}

> seg(kame)

# Segment  n Proportion
1       l 17      41.46
2       r 15      36.59
3       t  3       7.32
4       s  2       4.88
5       d  1       2.44
6       k  1       2.44
7       m  1       2.44
8       n  1       2.44

```

We can see that, given the string ```kame```, the next segment will be an ```[l]``` 40% of the time in Portuguese.
Next, you can also generate a **histogram** with the output above. 
Simply type ```pHist```. The histogram requires the ```extrafont``` package, so if you don't want 
to set a different font face, just delete that from the script.


## Script

```{r}

# First, load the lexicon you'll be using.
lex = read.csv('')

# In my case, I'll add a new column to the lexicon, which will remove the hyphens from all words.
# This is necessary here because the Portuguese Stress Corpus has syllabification 
	# included in the pronunciation column.

lex['string'] = gsub('[-\']', '\\1', lex$pro)


# Now, the function.

seg <- function(s){
	
	require(reshape2)
	require(ggplot2)
	require(scales)
	require(extrafont)
	require(Hmisc)
	
	input = as.character(substitute(s))
	
	s = paste('^', as.character(substitute(s)), sep='')
	
	nSeg = nchar(s)-1 # Number of segments
	
	set = lex[grepl(s, lex$string),] 	# Words with pattern
	
	if(nrow(set)==0){
		stop('This sequence does not exist in this language. Check the characters used in the input.')
	}
	
	
	words = subset(set, select=c('string'))
	
	words$string = as.character(words$string)
	
	splitWords = strsplit(words$string, '')
	
	boundary = c(words$string)
	
	if(all(nchar(boundary)==nSeg)){
		stop('This string is not followed by any segment in this language, which means you have hit a word boundary.')
	}
	
	output = c()
	
	
	for(i in 1:length(splitWords)){
		 output[length(output)+1] = splitWords[[i]][nSeg+1]
	}
	
	
	outputTable = table(output)
	
	outputTable = melt(sort(outputTable, decreasing=T))

	names(outputTable) = c('Segment', 'n')
	
	outputTable$Proportion = round(((outputTable$n)/sum(outputTable$n))*100,2)
	
		
# Below, I create a global variable for the histogram. This histogram contains my deafault settings, 
# so feel free to adapt it to your liking.

assign("pHist", ggplot(data=outputTable, aes(x=Segment, y=n)) + geom_histogram(stat='identity', alpha=0.5) 
	+ ggtitle(paste('[', input, '... ]', sep='')) + xlab('Following segment') + ylab('n') 
	+ theme_bw() + theme(plot.margin = unit(c(0.5, 0.5, 0.5, 0.5), 'cm'), 
	text=element_text(size=25, family="CMU Sans Serif", vjust=1.5), 
	legend.position = 'none', axis.title.y=element_text(vjust=1.3), 
	axis.title.x=element_text(vjust=-0.3)), envir = .GlobalEnv)
	
	return(outputTable)
	
}

# The function outputs a data frame. If you want to generate the histogram, simply follow the example above.


```




