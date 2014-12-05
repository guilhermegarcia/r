# Pseudo-random word generator

This script contains a single function for sampling a pre-defined number of words given some parameters. The function was originally developed for Portuguese, but it can be modified to match any other language. The function ```word()``` contains possible onsets, nuclei and codas (you can also include additional phonotactic rules). ```word()``` takes any number of arguments, each of which represents a segment in the word that will be generated.

First, I define possible monophthongs and diphthongs in the language (```V``` and ```VV```, respectively), as well as onsets and codas (note that positional differences can be reflected in additional variables). This makes it easier to edit the inventories. This function has no phonotact rules in it, but you can easily add them. Finally, the number of words generated can be changed by editing the ```for``` loop, which is now set to 100.

## Objective

The main objective of this function is to help you come up with 'random' pseudo-words (but see below) that follow a given template. The function merely concatenates samples from pre-defined vectors that contain segments (vowels, consoanants). It goes without saying that the output of the function will necessarily be verified and filtered, depending on what you are actually looking for. That being said, the idea here is to simply speed things up.

```{R}
word = function(...){
	
# Nuclei in the language

assign("V", c('a', 'e', 'i', 'o', 'u'), envir= .GlobalEnv)


assign("VV", c('ai', 'ei', 'oi', 'ui', 'Ei', 'oi', 'au', 'eu', 'ou', 'eu', 'Ou'), envir = .GlobalEnv)

# Note the glides {w,j}

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

```

## Some examples

Let's generate 100 words with the following shape: CV.CVC (note that syllabification is *not* part of the function).

```{R}

word(O,V,O,V,Cf) # where cf = final coda

 [1] "cilur"    "camer"   "dosus"   "lhager"  "fomur"   "gisos"  
 [7] "jomis"    "dudel"   "damis"   "madol"   "raquur"  "gifal"  
 [13] "rical"   "lenus"   "ligom"   "nhonhes" "zogil"   "zedas"  
 [19] "pefum"   "lutar"   "degar"   "gezel"   "dequim"  "nasem"  
 [25] "pivor"   "lhedul"  "lhoquil" "lobir"   "quelhes" "rasas"  
 [31] "najem"   "tagor"   "sanham"  "nhiqual" "tosor"   "rivos"  
 [37] "quivor"  "quafir"  "detol"   "tuzer"   "quacam"  "lalhes" 
 [43] "zuter"   "bocum"   "ponul"   "monhil"  "nabus"   "lelham" 
 [49] "nulhis"  "gelhel"  "dojol"   "jevim"   "jovem"   "bicem"  
 [55] "dutem"   "solar"   "sizil"   "rezol"   "garar"   "naros"  
 [61] "cagil"   "puquas"  "nhonhel" "nhalol"  "zugol"   "ziges"  
 [67] "nhatul"  "zodes"   "nacem"   "quozur"  "sebus"   "ginal"  
 [73] "jibor"   "vubol"   "jafem"   "gunhor"  "folhor"  "golhas" 
 [79] "caquur"  "nasol"   "lhevor"  "jenhir"  "lezus"   "quaros" 
 [85] "gisir"   "litul"   "jonhis"  "vasus"   "tanhol"  "banus"  
 [91] "toquor"  "lhajar"  "radol"   "pozum"   "lunhum"  "cumum"  
 [97] "dotel"   "jiner"   "lhadir"  "tedel"  
```

Although the function is meant to generate a sample of hypothetical words, by definition, not all generated words will be nonce-words. You can either manually exclude real words **or** you could simply add an extra step to the function, where you'd only return words that are not in a given corpus.

Let's now generate CVV.CV.CV words.

```{R}
word(O,VV,O,V,O,V)

 [1] "goucula"     "soigopa"    "nhaiquequa" "loinhafa"  
 [5] "laucoju"     "ceifode"    "juifici"    "rOutimo"   
 [9] "lheujuga"    "reipazi"    "jounhebu"   "suizove"   
 [13] "counadu"    "caugavo"    "peunhazu"   "voinhova"  
 [17] "zousanho"   "fairice"    "lainadu"    "geifido"   
 [21] "ruinique"   "nhaunhono"  "meicanu"    "zoubanhe"  
 [25] "gaumaja"    "loijecu"    "bOunajo"    "fuizade"   
 [29] "nhoinhemu"  "seisisi"    "taubeva"    "joifilo"   
 [33] "rOucoza"    "dEivipa"    "pOururi"    "duizuvo"   
 [37] "maulhinu"   "nhuimodo"   "jOubudu"    "pEitoquu"  
 [41] "geifeza"    "nheudiba"   "quoijopi"   "queusonhi" 
 [45] "zoirale"    "queisebi"   "puiparu"    "loijicu"   
 [49] "sainuquo"   "touzogu"    "peugemu"    "goubebu"   
 [53] "joujuve"    "zaudiquu"   "tuisipa"    "moitoba"   
 [57] "lhoivaju"   "ceisame"    "poidofo"    "lheulofu"  
 [61] "mEibive"    "geunado"    "nhEinuto"   "zeulile"   
 [65] "vuilhune"   "zEigepo"    "soicoma"    "veucaci"   
 [69] "paupeje"    "queutuge"   "nEitalu"    "soivuni"   
 [73] "voimera"    "daizoci"    "goirupo"    "soiguto"   
 [77] "quOuquefo"  "voicezo"    "faupofi"    "faufuzi"   
 [81] "goinhoci"   "ceucice"    "nuivuse"    "moivaru"   
 [85] "neuselhu"   "dounenhu"   "puiquinhu"  "deiquase"  
 [89] "lhoizege"   "nEinanhe"   "vuisuti"    "zaipinhu"  
 [93] "teinhinhe"  "dEifono"    "nEisafo"    "quoizute"  
 [97] "zuicise"    "quEijegu"   "boiguco"    "nhoizabi"
```
