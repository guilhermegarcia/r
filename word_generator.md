# Word generator

*Guilherme D. Garcia (McGill)*

**[Latest update: Dec 8th 2014]:** now, I've added a vector with sequences of segments you do not want to see in the outcome. I had mentioned you could add rules/restrictions, so this is an important example. Now, **all** generated words are well-formed. In addition, an extra argument is included in the function, ```n```, which is basically the approximate number of words you want.

This script contains a single function for sampling a pre-defined number of words given some parameters—in that sense, the function itself doesn't care which language you're working with. The function was originally developed for Portuguese, but it can be modified to match any other language. The function ```word()``` contains possible onsets, nuclei and codas (you can also include additional phonotactic rules, as this is a basic word generator). ```word()``` takes any number of arguments, each of which represents a segment in the word that will be generated. **After** you define the segments, you need to specify the approximate number of words you want to be generated.

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

Therefore, ```word(O,V,O,V,O,V,O,V, n=100)``` will generate 100 CV.CV.CV.CV words. However, you'll see that some of these words will have sequences of segments that are not well-formed in the language. For Portuguese, some examples are 'quu' and word-initial 'lh' (ok, **lhama** doesn't count). The updated version of the function (see above) includes a vector with all such sequences, so you can add as many as you want. Basically, ```out``` lists bad sequences (in ```regex``` format), and only words that do **not** contain such sequences are returned. For that reason, the number of iterations in ```n``` is multiplied by ```1.5``` in the function.


#### Download script [here](http://guilhermegarcia.github.io/resources/scripts/word_generator.R) and run it via ```source()```

Alternatively, use ```source('http://guilhermegarcia.github.io/resources/scripts/word_generator.R')```

-----

```{R}

# Copyright (c) 2014 Guilherme Duarte Garcia (under MIT license)

word = function(...,n){

if(missing(n)){stop('You forgot the (approx.) number of words.')} # Dont' forget to specify n

## First, let's define the parameters we're interested in (i.e., the inventory of *graphemes*)

# Nuclei in the language

assign("V", c('a', 'e', 'i', 'o', 'u'), envir= .GlobalEnv)


assign("VV", c('ai', 'ei', 'oi', 'ui', 'Ei', 'oi', 'au', 'eu', 'ou', 'eu', 'Ou'), envir = .GlobalEnv)

# Add any other parameter you'd like

# Onsets (singleton and complex)


assign("O", c('b', 'c', 'ç', 'd', 'f', 'g', 'gu', 'j', 'l', 'lh', 'nh', 'm', 'n', 'p', 'qu', 'r', 's', 't', 'v', 'z'), envir = .GlobalEnv)

assign("OO", c('cr', 'cl', 'dr', 'br', 'bl', 'fr', 'fl', 'gr', 'gl', 'pr', 'pl', 'tr', 'tl', 'vl', 'vr'), envir = .GlobalEnv)

# Other possible onsets should be added

# Sequences not allowed (a vector with sequences you don't want)---this uses regular expressions

out = c('quu', '^lh', '^nh', 'guu', 'quo', 'guo', 'll', 'mm', 'nn', 'sz', 'ç[ei]', '^ç')

# Codas (positionally neutral assumptions here)

assign("C", c('n', 'm', 'l', 's', 'r'), envir = .GlobalEnv)

##############################################################

# Now, the function per se, which basically uses loopings and samplings

args = list(...)    # creates a list with the arguments
temp =  list()      # empty list for storing samples of segments
words = list()      # empty list for storing random words

for(j in 1:(n*1.5)){    # this loop generates n*1.5 words
for(i in 1:length(args)){

    temp[[i]] = sample(args[[i]],1)
    }

word = paste(temp, sep = '', collapse = '')

words[j] = c(word)

}

badWords = c()     # This will store all the bad words (listed in the variable out above)

for(i in 1:length(out)){
    badWords[[length(badWords)+1]] <- words[grep(out[i],words)]
}

badWords = unlist(badWords)

finalList = words[!words %in% badWords]

return(unique(unlist(finalList)))

}


```

## Some examples

Let's generate (approx.) 100 words with the following shape: CV.CVC (note that syllabification is *not* part of the function).

```{R}

word(O,V,O,V,C, n=100)

  [1] "gomun"  "juras"  "redus"  "galhen" "fefar"  "ninhos"
  [7] "tavem"  "tazom"  "nevun"  "rones"  "vaçam"  "pebar" 
 [13] "cibir"  "jaral"  "jufil"  "larul"  "cenham" "galhos"
 [19] "bapon"  "suzon"  "vacur"  "dusan"  "fajar"  "buzol" 
 [25] "mobum"  "bajul"  "tibin"  "janhem" "fujen"  "nulhim"
 [31] "cigir"  "macim"  "salon"  "finam"  "dejul"  "zesar" 
 [37] "jusil"  "fujer"  "punel"  "vinhul" "zujem"  "rijis" 
 [43] "fofem"  "gecos"  "siges"  "dupor"  "ginhin" "cijun" 
 [49] "cipis"  "luvon"  "cafim"  "cemus"  "sirir"  "pabes" 
 [55] "mujir"  "filhim" "tiguil" "lenas"  "nuquar" "gises" 
 [61] "lupos"  "pagor"  "silun"  "nural"  "cabis"  "pulam" 
 [67] "zeguan" "putul"  "mipem"  "zamen"  "difar"  "canhis"
 [73] "tedon"  "jalil"  "dulas"  "vuvun"  "zinom"  "gasal" 
 [79] "salhes" "nobus"  "satun"  "tobul"  "muquim" "voner" 
 [85] "gacor"  "vomur"  "lecum"  "bonhir" "givis"  "jenas" 
 [91] "tufir"  "sanam"  "nibar"  "zorin"  "livar"  "tolur" 
 [97] "ziguas" "daran"  "migen"  "sulhel" "zitus"  "bujon" 
[103] "dinam" 


```

Although the function is meant to generate a sample of hypothetical words, by definition, not all generated words will be nonce-words. You can either manually exclude real words **or** you could simply add an extra step to the function, where you'd only return words that are not in a given corpus.

Let's now generate CVV.CV.CV words.

```{R}
word(O,VV,O,V,O,V, n=100)

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

Note that in both cases **more** than 100 words were returned, but fewer than 150. This is due to the words that contained sequences pre-defined as **bad** for this particular language.


-----

### How to cite this script

```{latex}
@misc{Garcia2014,
  author = {Garcia, Guilherme D.},
  title = {Word Generator: an R script for generating pseudo-random words},
  year = {2014},
  publisher = {GitHub},
  journal = {GitHub repository},
  url = {https://github.com/guilhermegarcia/r/blob/master/word_generator.md}
}
```
