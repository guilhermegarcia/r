# Pseudo-random word generator

This script contains a single function for sampling a pre-defined number of words given some parameters. The function was originally developed for Portuguese, but it can be modified to match any other language. The function ```word()``` contains possible onsets, nuclei and codas (you can also include additional phonotactic rules). ```word()``` takes any number of arguments, each of which represents a segment in the word that will be generated.

First, I define possible monophthongs and diphthongs in the language (```V``` and ```VV```, respectively), as well as onsets and codas (note that positional differences can be reflected in additional variables). This makes it easier to edit the inventories. This function has no phonotact rules in it, but you can easily add them. Finally, the number of words generated can be changed by editing the ```for``` loop, which is now set to 100.

## Objective

The main objective of this function is to help you come up with random pseudo-words that follow a given template. The function merely concatenates samples from pre-defined vectors that contain segments (vowels, consoanants). It goes without saying that the output of the function will necessarily be verified and filtered, depending on what you are actually looking for. That being said, the idea here is to simply speed things up.

```{R}
word = function(...){
	
# Nuclei in the language

assign("V", c('a', 'e', 'i', 'o', 'u'), envir= .GlobalEnv)


assign("VV", c('aj', 'ej', 'oj', 'uj', 'Ej', 'oj', 'aw', 'ew', 'ow', 'ew', 'Ow'), envir = .GlobalEnv)

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

Although the function is meant to generate random words, by definition, not all generated words will be nonce-words. You can either manually exclude real words **or** you could simply add an extra step to the function, where you'd only return words that are not in a given corpus.

Let's now generate CVV.CV.CV words.

```{R}
word(O,VV,O,V,O,V)

 [1] "tujrogu"    "nhawfera"  "rewbilhe"  "gewlega"   "cajpigi"  
 [6] "fejnefe"    "fajpapo"   "jOwmoli"   "rojcevu"   "zowgiqua" 
 [11] "lhawponhe" "tOwjuti"   "tOwpapu"   "cewzabi"   "pOwleba"  
 [16] "lhEjcute"  "dajdoje"   "cujmiqui"  "bawpudu"   "dujnova"  
 [21] "jownhadi"  "dajmopo"   "zewtoce"   "sawlane"   "pOwquise" 
 [26] "gewzino"   "jOwgina"   "lhujfosa"  "gEjmabi"   "pojpife"  
 [31] "rejnhece"  "lOwmunho"  "vojvape"   "fEjquijo"  "zojzizu"  
 [36] "quawrino"  "cojquinhu" "mejcude"   "dajrulu"   "nhajvole" 
 [41] "sojruqui"  "sawnhuju"  "lhowquodi" "zojgega"   "lhejlibe" 
 [46] "vejseti"   "quojfine"  "tOwcege"   "vawconu"   "fewnogo"  
 [51] "nEjdetu"   "tewsici"   "vejfara"   "cewculho"  "rewgiga"  
 [56] "tujgula"   "rejzuru"   "tEjjaju"   "sewpunhu"  "fujquane" 
 [61] "nhEjgole"  "fejdove"   "dojrato"   "towlhonhe" "nujpipu"  
 [66] "fEjfica"   "quewloca"  "powjelho"  "bOwsogi"   "towtose"  
 [71] "bawvulhe"  "tajnhila"  "pawdeno"   "cOwveba"   "pEjcode"  
 [76] "fojvipo"   "bEjnhoda"  "rojdoba"   "lhowluze"  "bujlhelhe"
 [81] "gOwnhelha" "jajravo"   "sewdude"   "cojdola"   "najlenhi" 
 [86] "pEjtana"   "bowjunho"  "sawnute"   "rojcisi"   "rojmenho" 
 [91] "lhewfala"  "bejjome"   "tojgudo"   "quujsiso"  "gOwgula"  
 [96] "bojlise"   "tejdibi"   "pewtifa"   "dojlhesa"  "cawnholi"
```
