



word = function(...){
	
# Nuclei in the language

assign("V", c('a', 'e', 'i', 'o', 'u'), envir= .GlobalEnv)


assign("VV", c('aj', 'ej', 'oj', 'uj', 'Ej', 'oj', 'aw', 'ew', 'ow', 'ew', 'Ow'), envir = .GlobalEnv)

# More options here

# Onsets (singleton and complex)


assign("O", c('b', 'c', 'd', 'f', 'g', 'j', 'l', 'lh', 'nh', 'm', 'n', 'p', 'qu', 'r', 's', 't', 'v', 'z'), envir = .GlobalEnv)

assign("OO", c('cr', 'cl', 'dr', 'br', 'bl', 'fr', 'fl', 'gr', 'gl', 'pr', 'pl', 'tr', 'tl', 'vl', 'vr'), envir = .GlobalEnv)

# Other possible onsets should be added

# Codas (word-interal and word-final)

assign("C", c('n', 'm', 'l', 's', 'r', 'c', 'p', 'b', 'd'), envir = .GlobalEnv)

assign("Cf", c('m', 'l', 's', 'r'), envir = .GlobalEnv)
	


args = list(...)	# creates a list with the arguments
temp = 	list()		# empty list for storing samples of segments
words = list() 		# empty list for storing random words

for(j in 1:100){
for(i in 1:length(args)){

	temp[[i]] = sample(args[[i]],1)
	}

word = paste(temp, sep = '', collapse = '')

words[j] = c(word)

}
return(unlist(words))

}

# Let's generate 100 words with the following template: onset, diphthong, onset, vowel, onset, vowel.
# This is equivalent to a CVG.CV.CV word.

word(O,VV,O,V,O,V)
