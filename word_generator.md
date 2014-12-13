# Word generator

*Guilherme D. Garcia (McGill)*  
<a href="http://www.guilherme.ca", target="_blank">guilherme.ca</a>

**[Latest update: Dec 10th]:** Type citeScript() for citation information. **[Dec 9th 2014]:** The scrip now has one more function: ```plotVowels()```. This allows you to plot the vowel distribution in the sample generated with ```word()```. **[Dec 8th 2014]:** now, I've added a vector with sequences of segments you do not want to see in the outcome. I had mentioned you could add rules/restrictions, so this is an important example. Now, **all** generated words are well-formed. In addition, an extra argument is included in the function, ```n```, which is basically the approximate number of words you want.

-----

## Welcome

This script contains a single function for sampling a pre-defined number of words given some parameters—in that sense, the function itself doesn't care which language you're working with. The function was originally developed for Portuguese, but it can be modified to match any other language. The function ```word()``` contains possible onsets, nuclei and codas (you can also include additional phonotactic rules). ```word()``` takes any number of arguments, each of which represents a segment in the word that will be generated. **After** you define the segments, you need to specify the approximate number of words you want to be generated.

First, I define monophthongs and diphthongs in the language (```V``` and ```VV```, respectively), as well as onsets and codas (note that positional differences can be reflected in additional variables). This makes it easier to edit the inventories. This function has no phonotact rules in it, but you can easily add them. Finally, the number of words generated can be changed by editing the ```for``` loop, which used to be set to 100 (see below).

## Objective

The main objective of this function is to help you come up with (pseudo-)'random' words that follow a given template. The function merely concatenates samples from pre-defined vectors that contain segments (vowels, consoanants). It goes without saying that the output of the function will need to be verified and filtered, depending on what you are actually looking for. That being said, the idea here is to simply speed things up. Crucially, as you have total control over the function, you can create inventories that match exactly the target configuration you want to include in your experiment(s). So this would be an advantage over more user-friendly (and therefore more restricted) apps that create wugs.

#### Some guidelines (given the variables defined below):

```word(...,n)``` where ```n``` is the approximate number of words you want  

```O``` stands for a singleton onset  
```OO``` stands for a complex onset  
```V``` stands for a single vowel  
```VV``` stands for a diphthong  (capital letters = low-mid vowels)  
```C``` stands for a coda consonant  

(By default, there are no complex codas in script. Simply edit the empty vector ```CC```).

Therefore, ```word(O,V,O,V,O,V,O,V, n=100)``` will generate 100 CV.CV.CV.CV words. However, you'll see that some of these words will have sequences of segments that are not well-formed in the language. For Portuguese, some examples are 'quu' and word-initial 'lh' (ok, **lhama** doesn't count). The updated version of the function (see above) includes a vector with all such sequences, so you can add as many as you want. Basically, ```out``` lists bad sequences (in ```regex``` format), and only words that do **not** contain such sequences are returned. As a result, the number of words that is actually returned will deviate from ```n``` (how much it deviates depends on your input). For that reason, the number of iterations in ```n``` is multiplied by ```1.5``` in the function, in an attempt to reduce this deviation. You could just use a large enough ```n```.

-----

### How to use this script

Download script [here](http://guilhermegarcia.github.io/resources/scripts/word_generator.R).

**OR** simply run it via ```source('http://guilhermegarcia.github.io/resources/scripts/word_generator.R')```

-----

```{R}

# Licensed under MIT license

# Copyright (c) 2014 Guilherme Duarte Garcia

# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this script and associated documentation files (the "Script"), to deal
# in the Script without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Script, and to permit persons to whom the Script is
# furnished to do so, subject to the following conditions:

# The above copyright notice and this permission notice shall be included in
# all copies or substantial portions of the Script.

# THE SCRIPT IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SCRIPT OR THE USE OR OTHER DEALINGS IN
# THE SCRIPT.

#################################################################### Enjoy.

cat('\n\n\nCopyright (c) 2014 Guilherme Duarte Garcia \n\nword(...,n) generates n *unique* words. 
Note that n is approximate, and will depend on your input. 
You can also plot the vowel distribution using plotVowels().
The script contains inventories for Portuguese.
You can change the parameters to generate words in other languages.
\nTypes of arguments: 
\nO -> singleton onset \nOO -> complex onset \nV -> monophthong \nVV -> diphthong 
C -> coda \n\nBy default, there are no complex codas.
Simply edit the empty vector (CC) in the script.
\nReference: O,V,C,O,V,O,V = CVC.CV.CV 
\nExample: 
\ntest <- word(O,V,C,n=80) # This will generate approx. 80 CVC words
plotVowels(test) # This will plot the vowel distribution in the sample

\nFor more information, type readMore() or visit:
\nhttps://github.com/guilhermegarcia/r/blob/master/word_generator.md \n
To cite this script, type  citeScript().\n\n\n')

require(scales)
require(ggplot2)


word = function(...,n){



## First, let's define the parameters we're interested in (i.e., the inventory of *graphemes*)

# Nuclei in the language

assign("V", c('a', 'e', 'i', 'o', 'u'), envir = .GlobalEnv)


# Falling diphthongs

assign("VV", c('ai', 'ei', 'oi', 'ui', 'Ei', 'Oi', 'au', 'eu', 'ou', 'Eu', 'Ou', 'iu'), envir = .GlobalEnv)

# Add any other parameter you'd like

# Onsets (singleton and complex)


assign("O", c('b', 'c', 'ç', 'd', 'f', 'g', 'gu', 'j', 'l', 'lh', 'nh', 'm', 'n', 'p', 'qu', 'r', 's', 't', 'v', 'z'), envir = .GlobalEnv)

assign("OO", c('cr', 'cl', 'dr', 'br', 'bl', 'fr', 'fl', 'gr', 'gl', 'pr', 'pl', 'tr', 'tl', 'vl', 'vr'), envir = .GlobalEnv)

# Other possible onsets should be added

# Sequences not allowed (a vector with sequences you don't want)---this uses regular expressions

out = c('quu', '^lh', '^nh', 'guu', 'quo', 'guo', 'll', 'mm', 'nn', 'mn', 'nm', 'sz', 'ç[ei]', '^ç', 'md', 'mk', 'mt', 'mg', 'np', 'nb', 'mf', 'mv', 'ms', 'mz', 'mc', 'mqu', 'mr', 'mç', 'ml', 'sj', 'lr', 'mj', '[bcçdfgjlmnpqrstvz]lh', '[bcçdfgjlmnpqrstvz]nh', 'sr', 'lj', 'rrr', 'sss')

# Codas (positionally neutral assumptions here)

assign("C", c('n', 'm', 'l', 's', 'r'), envir = .GlobalEnv)

assign("CC", c()) # Add complex codas here

##############################################################

# Now, the function per se, which basically uses loopings and samplings

args = list(...)    # creates a list with the arguments

if(length(args)==0){stop('You need a valid input.')}
if(missing(n)){stop('You forgot the (approx.) number of words: n = ?')}

temp =  list()      # empty list for storing samples of segments
words = list()      # empty list for storing random words

for(j in 1:(n*1.5)){    # this loop generates n words (here, n=100)
for(i in 1:length(args)){

    temp[[i]] = sample(args[[i]],1)
    }

word = paste(temp, sep = '', collapse = '')

words[j] = c(word)

}

badWords = c()

for(i in 1:length(out)){
    badWords[[length(badWords)+1]] <- words[grep(out[i],words)]
}

badWords = unlist(badWords)

finalList = words[!words %in% badWords]


return(unique(unlist(finalList)))



}


# This will plot the vowel distribution of the corpus generated with word() above.

plotVowels = function(x){
	
	if(missing(x)){stop('Your input needs to be a corpus generated via word()')}
	if(class(x)!='character'){stop('Wrong input.')}
	assign("syllabic", c('a','e','i','o','u'), envir = .GlobalEnv)
	
	temp = strsplit(x,'')
	temp = unlist(temp)
	temp = tolower(temp)
	allVowels = list()
	
	
	for(i in 1:length(temp)){
		if(temp[i] %in% syllabic){
			allVowels[[length(allVowels)+1]] <- c(temp[i])
		}
	}
	
	allVowels = data.frame(table(unlist(allVowels)))
	names(allVowels) <- c('Vowel', 'Frequency')
	allVowels$Proportion <- allVowels$Frequency / sum(allVowels$Frequency)
	
	distribution = ggplot(data=allVowels, aes(x=Vowel, y=Proportion)) + geom_histogram(stat='identity', fill='white', color='black') + ylab(NULL) + xlab('Vowel') + theme_bw() + ggtitle('Distribution of vowels') + theme(text=element_text(size=20)) + scale_y_continuous(labels=percent)
	
	return(distribution)
	
}



# For more information, type readMore() to visit the website

readMore = function(){
    browseURL("https://github.com/guilhermegarcia/r/blob/master/word_generator.md")
    }
    
    

citeScript = function(){
	
	cat('\nAPA:
\nGarcia, G. D. (2014). Word Generator: an R script for generating pseudo-random words. GitHub repository available at https://github.com/guilhermegarcia/r/blob/master/word_generator.md
\nABNT:
\nGARCIA, Guilherme D. Word Generator: an R script for generating pseudo-random words. GitHub repository disponível em https://github.com/guilhermegarcia/r/blob/master/word_generator.md, 2014.\n\n')
}



```

Although ```word()``` is meant to generate a sample of hypothetical words, by definition, not all generated words will be nonce-words. You can either manually exclude real words **or** you could simply add an extra step to the function, where you'd only return words that are not in a given corpus.

Let's generate CVV.CV.CV words.

```{R}
corpus <- word(O,VV,O,V,O,V, n=100)
corpus

  [1] "toipavo"    "cuituzu"    "mOuguiri"   "tEigaba"   
  [5] "lainhugui"  "voupace"    "voidade"    "jouquise"  
  [9] "baifeca"    "nuigale"    "boiviti"    "nuimosi"   
 [13] "sOufusi"    "tuideno"    "vaujege"    "puizire"   
 [17] "loituca"    "meuvalhu"   "naurigua"   "çOuguane"  
 [21] "doifuzi"    "mEibaça"    "vaunhefe"   "guaiseji"  
 [25] "reujugo"    "paibibe"    "zEinoci"    "jeizosa"   
 [29] "deuduni"    "ceilhubu"   "jeilhora"   "jeusosu"   
 [33] "mEimoju"    "tEiroce"    "gEipunhi"   "reuquimi"  
 [37] "vaulhedu"   "loinuci"    "bouviva"    "teudote"   
 [41] "suizagi"    "ceuziru"    "zaunicu"    "voiguaba"  
 [45] "mOurile"    "jeumibe"    "moinhoju"   "reiquelhe" 
 [49] "gaizogui"   "doivaga"    "saibiga"    "doufiti"   
 [53] "veuropa"    "zeunodi"    "zEinhadu"   "fEiquimi"  
 [57] "nEicalo"    "dOumuse"    "foufuge"    "zeuguago"  
 [61] "meucipo"    "beucelhe"   "fuivafa"    "feumira"   
 [65] "neunene"    "quEifoça"   "geuducu"    "boigula"   
 [69] "mailhuna"   "pEipade"    "quaigova"   "zEipalhe"  
 [73] "nauruva"    "zeunufe"    "rEimebo"    "luifala"   
 [77] "jOujalhe"   "faulenhe"   "geidunha"   "tauquade"  
 [81] "paiquaba"   "coitagua"   "teulhanu"   "cEiguina"  
 [85] "meuleti"    "boinubu"    "joiledu"    "meufisa"   
 [89] "foidono"    "foidaja"    "voujique"   "dEitogo"   
 [93] "queulhuqui" "reuquaça"   "tounega"    "queuguelho"
 [97] "rouvica"    "rauquazi"   "peubuja"    "gueunhaza" 
[101] "loiromo"    "vuiguaqui"  "guipafa"    "gOusiro"   
[105] "sEinhiro"   "feunhunhu"  "nauzozo"    "peibaca"   
[109] "zauçanhu"   "caucipo"    "voilhasu"   "ceigolho"  

```

Note that **more** than 100 words were returned, but fewer than 150. This is due to the words that contained sequences pre-defined as **bad** for this particular language. Finally, if you wanted to plot the vowel distribution of the corpus above:

```{r}
plotVowels(corpus)

```


-----

### How to cite this script
```{latex}
@manual{Garcia2014,
  author = {Garcia, Guilherme D.},
  title = {Word {G}enerator: an {R} script for generating pseudo-random words},
  year = {2014},
  note = {GitHub repository available at \url{https://github.com/guilhermegarcia/r/blob/master/word_generator.md}}
  }
```

##### APA:

Garcia, G. D. (2014). Word Generator: an R script for generating pseudo-random words. GitHub repository available at https://github.com/guilhermegarcia/r/blob/master/word_generator.md

##### ABNT:

GARCIA, Guilherme D. Word Generator: an R script for generating pseudo-random words. GitHub repository disponível em https://github.com/guilhermegarcia/r/blob/master/word_generator.md, 2014.
