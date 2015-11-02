## Phonological similarity

This script contains a function that compares two strings and returns a similarity score. The score takes into account the
phonological features of each segment in each of the two strings in question. Segment ```i``` in ```string1``` is compared to segment
```i``` in ```string2``` and so forth (until the last segment of the shortest string is reached).

### Example

```pSim("banana", "bana")``` will return **0**, because the first 4 segments in both strings are identical regarding their
phonological features. If you are comparing words that differ in length, you may want to take that into account. In other words, you may not like the fact that ```banana``` and ```bana``` are considered to be identical feature-wise. For that reason, a third argument is also available.

### String similarity beyond features

A third argument, ```distance``` allows the user to take into account other structural differences between the inputs (check the package [```stringdist```](https://cran.r-project.org/web/packages/stringdist/stringdist.pdf) for more information). A very common method is the **Levenshtain distance** (*Minimal number of insertions, deletions and replacements needed for transforming string a into string b*):    

```pSim("banana", "bana", distance="lv")```   

Now, the score will be **0.25**. This final score is basically 50% based on the string distance metric (```lv```) and 50% based on phonological similarity between the two strings (you can obviously adjust these weights in the function). If no distance method is provided in the function, only features will be compared.

The function is based on Portuguese (given the inventory below). Other languages can be easily added by adapting said inventory. 

### Features

All segments are defined as basic variables (lists). This is advantageous because you can use **any** function available in ```R```. For example, set operations. Let's say you want to check which features the segment ```p``` contains that ```t``` does not contain. To list such features, you'd only need to use the ```setdiff(p,t)```. Note that I did not use quotation marks, since the segments are **variables** in this script. This will list all features that are unique to ```p```.

### Transcription (conventions)

You can change this, but the convention I'm using is as follows:    
```M``` a syllable-final nasal (engma)    

Overall, this is the same convention I use in the Portuguese Stress Corpus (<a href="https://github.com/guilhermegarcia/portuguese_corpus/wiki/2.-Transcription", target="_blank"><b>here</b></a>).


```{r}
# Guilherme D. Garcia (2015)


pSim = function(word1,word2, distance="none"){

# Distance options: "osa", "lv", "dl", "hamming", "lcs", "qgram", "cosine", "jaccard", "jw", "soundex"

# First, let's define the inventory for Portuguese (with all features).

p = list("−syllabic", "−stress", "−long", "+consonantal" ,"−sonorant", "−continuant", "−delayed release", "−approximant", "−tap","−trill", "−nasal", "−voice", "−spread gl", "−constr gl", "+labial", "−round", "−labiodental", "−coronal" ,"0anterior", "0distributed", "0strident", "−lateral", "−dorsal", "0high", "0low", "0front", "0back", "0tense")

t = list("−syllabic", "−stress", "−long", "+consonantal", "−sonorant", "−continuant", "−delayed release", "−approximant", "−tap", "−trill", "−nasal", "−voice", "−spread gl", "−constr gl", "−labial", "−round", "−labiodental", "+coronal", "+anterior", "−distributed", "−strident", "−lateral", "−dorsal", "0high", "0low", "0front", "0back", "0tense")

k = list("−syllabic", "−stress", "−long", "+consonantal", "−sonorant", "−continuant", "−delayed release", "−approximant", "−tap", "−trill", "−nasal", "−voice", "−spread gl", "−constr gl", "−labial", "−round", "−labiodental", "−coronal", "0anterior", "0distributed", "0strident", "−lateral", "+dorsal", "+high", "−low", "0front", "0back", "0tense")

b = list("−syllabic", "−stress", "−long", "+consonantal" ,"−sonorant", "−continuant", "−delayed release", "−approximant", "−tap","−trill", "−nasal", "+voice", "−spread gl", "−constr gl", "+labial", "−round", "−labiodental", "−coronal" ,"0anterior", "0distributed", "0strident", "−lateral", "−dorsal", "0high", "0low", "0front", "0back", "0tense")

d = list("−syllabic", "−stress", "−long", "+consonantal", "−sonorant", "−continuant", "−delayed release", "−approximant", "−tap", "−trill", "−nasal", "+voice", "−spread gl", "−constr gl", "−labial", "−round", "−labiodental", "+coronal", "+anterior", "−distributed", "−strident", "−lateral", "−dorsal", "0high", "0low", "0front", "0back", "0tense")

g = list("−syllabic", "−stress", "−long", "+consonantal", "−sonorant", "−continuant", "−delayed release", "−approximant", "−tap", "−trill", "−nasal", "+voice", "−spread gl", "−constr gl", "−labial", "−round", "−labiodental", "−coronal", "0anterior", "0distributed", "0strident", "−lateral", "+dorsal", "+high", "−low", "0front", "0back", "0tense")

X = list("−syllabic", "−stress", "−long", "+consonantal", "−sonorant", "−continuant", "+delayed release", "−approximant", "−tap", "−trill", "−nasal", "−voice", "−spread gl", "−constr gl", "−labial", "−round", "−labiodental", "+coronal", "−anterior", "+distributed", "+strident", "−lateral", "−dorsal", "0high", "0low", "0front", "0back", "0tense")

D = list("−syllabic", "−stress", "−long", "+consonantal", "−sonorant", "−continuant", "+delayed release", "−approximant", "−tap", "−trill", "−nasal", "+voice", "−spread gl", "−constr gl", "−labial", "−round", "−labiodental", "+coronal", "−anterior", "+distributed", "+strident", "−lateral", "−dorsal", "0high", "0low", "0front", "0back", "0tense")

f = list("−syllabic", "−stress", "−long", "+consonantal", "−sonorant", "+continuant", "+delayed release", "−approximant", "−tap", "−trill", "−nasal", "−voice", "−spread gl", "−constr gl", "+labial", "−round", "+labiodental", "−coronal", "0anterior", "0distributed", "0strident", "−lateral", "−dorsal", "0high", "0low", "0front", "0back", "0tense")

s = list("−syllabic", "−stress", "−long", "+consonantal", "−sonorant", "+continuant", "+delayed release", "−approximant", "−tap", "−trill", "−nasal", "−voice", "−spread gl", "−constr gl", "−labial", "−round", "−labiodental", "+coronal", "+anterior", "−distributed", "+strident", "−lateral", "−dorsal", "0high", "0low", "0front", "0back", "0tense")

S = list("−syllabic", "−stress", "−long", "+consonantal", "−sonorant", "+continuant", "+delayed release", "−approximant", "−tap", "−trill", "−nasal", "−voice", "−spread gl", "−constr gl", "−labial", "−round", "−labiodental", "+coronal", "−anterior", "+distributed", "+strident", "−lateral", "−dorsal", "0high", "0low", "0front", "0back", "0tense")

v = list("−syllabic", "−stress", "−long", "+consonantal", "−sonorant", "+continuant", "+delayed release", "−approximant", "−tap", "−trill", "−nasal", "+voice", "−spread gl", "−constr gl", "+labial", "−round", "+labiodental", "−coronal", "0anterior", "0distributed", "0strident", "−lateral", "−dorsal", "0high", "0low", "0front", "0back", "0tense")

z = list("−syllabic", "−stress", "−long", "+consonantal", "−sonorant", "+continuant", "+delayed release", "−approximant", "−tap", "−trill", "−nasal", "+voice", "−spread gl", "−constr gl", "−labial", "−round", "−labiodental", "+coronal", "+anterior", "−distributed", "+strident", "−lateral", "−dorsal", "0high", "0low", "0front", "0back", "0tense")

Z = list("−syllabic", "−stress", "−long", "+consonantal", "−sonorant", "+continuant", "+delayed release", "−approximant", "−tap", "−trill", "−nasal", "+voice", "−spread gl", "−constr gl", "−labial", "−round", "−labiodental", "+coronal", "−anterior", "+distributed", "+strident", "−lateral", "−dorsal", "0high", "0low", "0front", "0back", "0tense")

m = list("−syllabic", "−stress", "−long", "+consonantal", "+sonorant", "−continuant", "0delayed release", "−approximant", "−tap", "−trill", "+nasal", "+voice", "−spread gl", "−constr gl", "+labial", "−round", "−labiodental", "−coronal", "0anterior", "0distributed", "0strident", "−lateral", "−dorsal", "0high", "0low", "0front", "0back", "0tense")

n = list("−syllabic", "−stress", "−long", "+consonantal", "+sonorant", "−continuant", "0delayed release", "−approximant", "−tap", "−trill", "+nasal", "+voice", "−spread gl", "−constr gl", "−labial", "−round", "−labiodental", "+coronal", "+anterior", "−distributed", "−strident", "−lateral", "−dorsal", "0high", "0low", "0front", "0back", "0tense")

N = list("−syllabic", "−stress", "−long", "+consonantal", "+sonorant", "−continuant", "0delayed release", "−approximant", "−tap", "−trill", "+nasal", "+voice", "−spread gl", "−constr gl", "−labial", "−round", "−labiodental", "+coronal", "−anterior", "+distributed", "−strident", "−lateral", "+dorsal", "+high", "−low", "+front", "−back", "0tense")

j = list("−syllabic", "−stress", "−long", "−consonantal", "+sonorant", "+continuant", "0delayed release", "+approximant", "−tap", "−trill", "−nasal", "+voice", "−spread gl", "−constr gl", "−labial", "−round", "−labiodental", "−coronal", "0anterior", "0distributed", "0strident", "−lateral", "+dorsal", "+high", "−low", "+front", "−back", "+tense")

l = list("−syllabic", "−stress", "−long", "+consonantal", "+sonorant", "+continuant", "0delayed release", "+approximant", "−tap", "−trill", "−nasal", "+voice", "−spread gl", "−constr gl", "−labial", "−round", "−labiodental", "+coronal", "+anterior", "−distributed", "−strident", "+lateral", "−dorsal", "0high", "0low", "0front", "0back", "0tense")

L = list("−syllabic", "−stress", "−long", "+consonantal", "+sonorant", "+continuant", "0delayed release", "+approximant", "−tap", "−trill", "−nasal", "+voice", "−spread gl", "−constr gl", "−labial", "−round", "−labiodental", "+coronal", "−anterior", "+distributed", "−strident", "+lateral", "+dorsal", "+high", "−low", "+front", "−back", "0tense")

w = list("−syllabic", "−stress", "−long", "−consonantal", "+sonorant", "+continuant", "0delayed release", "+approximant", "−tap", "−trill", "−nasal", "+voice", "−spread gl", "−constr gl", "+labial", "+round", "−labiodental", "−coronal", "0anterior", "0distributed", "0strident", "−lateral", "+dorsal", "+high", "−low", "−front", "+back", "+tense")

i = list("+syllabic", "−stress", "−long", "−consonantal", "+sonorant", "+continuant", "0delayed release", "+approximant", "−tap", "−trill", "−nasal", "+voice", "−spread gl", "−constr gl", "−labial", "−round", "−labiodental", "−coronal", "0anterior", "0distributed", "0strident", "−lateral", "+dorsal", "+high", "−low", "+front", "−back", "+tense")

u = list("+syllabic", "−stress", "−long", "−consonantal", "+sonorant", "+continuant", "0delayed release", "+approximant", "−tap", "−trill", "−nasal", "+voice", "−spread gl", "−constr gl", "+labial", "+round", "−labiodental", "−coronal", "0anterior", "0distributed", "0strident", "−lateral", "+dorsal", "+high", "−low", "−front", "+back", "+tense")

e = list("+syllabic", "−stress", "−long", "−consonantal", "+sonorant", "+continuant", "0delayed release", "+approximant", "−tap", "−trill", "−nasal", "+voice", "−spread gl", "−constr gl", "−labial", "−round", "−labiodental", "−coronal", "0anterior", "0distributed", "0strident", "−lateral", "+dorsal", "−high", "−low", "+front", "−back", "+tense")

o = list("+syllabic", "−stress", "−long", "−consonantal", "+sonorant", "+continuant", "0delayed release", "+approximant", "−tap", "−trill", "−nasal", "+voice", "−spread gl", "−constr gl", "+labial", "+round", "−labiodental", "−coronal", "0anterior", "0distributed", "0strident", "−lateral", "+dorsal", "−high", "−low", "−front", "+back", "+tense")

E = list("+syllabic", "−stress", "−long", "−consonantal", "+sonorant", "+continuant", "0delayed release", "+approximant", "−tap", "−trill", "−nasal", "+voice", "−spread gl", "−constr gl", "−labial", "−round", "−labiodental", "−coronal", "0anterior", "0distributed", "0strident", "−lateral", "+dorsal", "−high", "−low", "+front", "−back", "−tense")

O = list("+syllabic", "−stress", "−long", "−consonantal", "+sonorant", "+continuant", "0delayed release", "+approximant", "−tap", "−trill", "−nasal", "+voice", "−spread gl", "−constr gl", "+labial", "+round", "−labiodental", "−coronal", "0anterior", "0distributed", "0strident", "−lateral", "+dorsal", "−high", "−low", "−front", "+back", "−tense")

a = list("+syllabic", "−stress", "−long", "−consonantal", "+sonorant", "+continuant", "0delayed release", "+approximant", "−tap", "−trill", "−nasal", "+voice", "−spread gl", "−constr gl", "−labial", "−round", "−labiodental", "−coronal", "0anterior", "0distributed", "0strident", "−lateral", "+dorsal", "−high", "+low", "−front", "−back", "0tense")

M = list("−syllabic", "−stress", "−long", "+consonantal", "+sonorant", "−continuant", "0delayed release", "−approximant", "−tap", "−trill", "+nasal", "+voice", "−spread gl", "−constr gl", "−labial", "−round", "−labiodental", "−coronal", "0anterior", "0distributed", "0strident", "−lateral", "+dorsal", "+high", "−low", "0front", "0back", "0tense")

r = list("−syllabic", "−stress", "−long", "+consonantal", "+sonorant", "+continuant", "0delayed release", "+approximant", "+tap", "−trill", "−nasal", "+voice", "−spread gl", "−constr gl", "−labial", "−round", "−labiodental", "+coronal", "+anterior", "−distributed", "−strident", "−lateral", "−dorsal", "0high", "0low", "0front", "0back", "0tense")

R = list("−syllabic", "−stress", "−long", "+consonantal", "−sonorant", "+continuant", "+delayed release", "−approximant", "−tap", "−trill", "−nasal", "−voice", "−spread gl", "−constr gl", "−labial", "−round", "−labiodental", "−coronal", "0anterior", "0distributed", "0strident", "−lateral", "+dorsal", "+high", "−low", "0front", "0back", "0tense")
	
lens = c(nchar(word1), nchar(word2))

segW1 = strsplit(word1, split="")[[1]]

segW2 = strsplit(word2, split="")[[1]]

SEG = c(segW1, segW2)

inventory = c('a', 'e', 'i', 'o', 'u', 'O', 'E', 'b', 'd', 'f', 'g', 'j', 'k', 'l', 'L', 'm', 'M', 'n', 'N', 'p', 'r', 's', 'S', 't', 'v', 'z', 'Z', 'X', 'D', 'w', 'R')


if(length(which(!SEG %in% inventory)) > 0){
	stop(paste("All your segments must be in the inventory used. Problem:", SEG[which(!SEG %in% inventory)]))
}

score = 0

w1 = segW1[1:min(lens)]
w2 = segW2[1:min(lens)]
	
for(i in 1:min(lens)){
	score = score + length(setdiff(get(segW1[i]),get(segW2[i])))/28
	}

dist = 0

if(distance != 'none'){
	
	dist = stringdist(word1, word2, method = distance)
	
	score = 0.5*score + 0.5*dist	
}

return(score/min(lens))

}




```
