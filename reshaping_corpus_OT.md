# Reshaping a dataset for OT-ish applications

This function is very specific, as I needed to turn a data frame into a list of unique combinations of variables,
include proportions, constraints, and assign violation marks. I used this for my 2014 paper on Gradient weight and stress,
where I propose an interval-based approach to stress in Portuguese. Because I wanted to map my analysis into a MaxEnt grammar
(Hayes & Wilson 2008), I needed the data to be in a specific format (see below).

I obviously don't assume you need a function that does exactly this, but you can definitely adapt this function. The idea is
to show you how I did it. Hopefully, this will be helpful if you want to do something similar (or a sub/superset of what I did).

## Summary: from A to B

My data looked like ```A``` below, and I needed something like ```B```. In ```A```, there are four columns. Each row is a
word in the lexicon. The first three columns tell you how many segments there are in all three intervals (see Steriade 2012)
in the stress domain (n=3)—```INT1``` coincides with the right edge of the word. The fourth column tells you what is the stress in the word: final = ```1```, penult = ```2``` and
antepenult = ```3```. The original data frame had tens of columns, so ```A``` below is already a simplified version of the data.
The function, however, doesn't care about that: as long as your columns are in the data, that's fine.


### A

```{R}
A

      INT3 INT2 INT1   stress
1     1    3    1      2
2     1    3    1      2
3     0    1    1      2
4     2    2    1      2
5     3    3    1      2
6     3    3    1      2
7     2    2    1      2
8     2    2    1      2
9     0    1    2      1
10    2    2    1      2

```

### B

```{R}
                        Constraint 1  Constraint 2  Constraint 3
Input   Output1   %       
        Output2   %
        Output3   %

```

OK, let's clarify this: each input is supposed to be a unique sequence of intervals (the first three columns in ```A```). Then,
the outputs are the three possible stress positions in Portuguese. Next, ```%``` stands for the proportion of words with that
sequence of intervals that fall into each of the stress patterns (outputs). The constraints here will be a modified version of
WSP (Weight-to-Stress Principle, Prince 1990; Prince & Smolensky 1993). Basically, if a word has 3 segments in interval 3 and 
penult stress, then this word violates WSP3 three times—but it violates WSP2 zero times, since it has penult stress. Thus, 
we can define WSPn as:

```
Let n be an unstressed position in the stress domain.
    WSPn  Assign one violation mark to every segment in n
```

## Steps

These are (roughly) the steps the function needs to follow:

Given a data frame x,

1. Select all unique interval sequences in x
2. For each sequence, calculate the proportion of final, penult and antepenult stress in x
3. Create new columns and add the data in (2) above
4. Create a column where all three intervals are merged, so that three columns become one
5. Reshape the data so that the stress patterns are rows, not columns
6. Order the data by interval sequence (i.e., input)
7. Add columns for constraints
8. Assign violation marks
9. Adjust column names
10. Print new data frame (and save a csv version in the current directory)


## Function

```{R}
toMax = function(x){
	
	require(reshape2)
	
	ints = unique(x[,c('INT3', 'INT2', 'INT1')])
	ints$APU = NA
	ints$PU = NA
	ints$U = NA
	
	pat <- function(x,y,z) {
	ints <- subset(data, INT3 == x & INT2 == y & INT1 == z, select=c('word','INT3', 'INT2', 'INT1', 'stress'))
	ints$stress = factor(ints$stress, levels=1:3)
	props <- prop.table(xtabs(~factor(stress, levels=1:3), ints))
	return(props)
}
	
	
	for(i in 1:nrow(ints)){
		temp = pat(ints[i,1], ints[i,2], ints[i,3])
		
		ints[i,4] = temp[[3]]
		ints[i,5] = temp[[2]]
		ints[i,6] = temp[[1]]
	}
	
	ints['Pattern'] = paste(ints$INT3, ints$INT2, ints$INT1, sep='')
	
	ints = subset(ints, select=c('Pattern', 'APU', 'PU', 'U'))
	
	ints$Pattern <- as.factor(ints$Pattern)

	ints <- melt(ints, id.vars='Pattern')

	ints <- ints[order(ints$Pattern),]
	
	rownames(ints) = NULL
	

	## Constraint violations
	
	ints$WSP3 = NA
	ints$WSP2 = NA
	ints$WSP1 = NA
	
	for(i in 1:nrow(ints)){
		
		if(ints[i,2] == 'APU' & substring(ints[i,1],1,1) == '0'){
			ints[i,4] <- 0
			ints[i,5] <- 0
			ints[i,6] <- 0
			
			} else if(ints[i,2] == 'APU' & substring(ints[i,1],1,1) != '0') {
			ints[i,4] <- 0
			ints[i,5] <- substring(ints[i,1], 2,2)
			ints[i,6] <- substring(ints[i,1], 3,3)
		} else if(ints[i,2] == 'PU'){
				
			ints[i,5] <- 0
			ints[i,4] <- substring(ints[i,1], 1,1)
			ints[i,6] <- substring(ints[i,1], 3,3)
		} else {
				
			ints[i,4] <- substring(ints[i,1], 1,1)
			ints[i,5] <- substring(ints[i,1], 2,2)
			ints[i,6] <- 0
		}
		
	} 
	
	
	# Finally, this is so we have only one input per eval
	
	ints$rows <- seq(1,nrow(ints))
	
	sequence = seq(1, 258, by = 3)
	
	for(i in 1:nrow(ints)){
	
	if(!ints[i,7] %in% sequence){
		ints[i,1] <- NA
	} else {
		ints[i,1] <- ints[i,1]
	}
		
	}
	
	ints <- subset(ints, select=c('Pattern', 'variable', 'value', 'WSP3', 'WSP2', 'WSP1'))
	
	names(ints) <- c('Input', 'Output', 'Frequency', 'WSP3', 'WSP2', 'WSP1')
	
	write.csv(ints, 'ints.csv', row.names=F, quote=F)
	print(ints, na.print='')
	
}


```


## Sample

These are the first 24 lines of the output. Note that ```WSP3``` is never violated here, since the interval sequences in this 
sample correspond to disyllables.


```{R}

      Input  Output   	Frequency      WSP3 WSP2 WSP1
1     011    APU 	0.000000000    0    0    0
2             PU 	0.250000000    0    0    1
3              U 	0.750000000    0    1    0
4     012    APU 	0.000000000    0    0    0
5             PU 	0.300000000    0    0    2
6              U 	0.700000000    0    1    0
7     013    APU  	0.000000000    0    0    0
8             PU 	0.000000000    0    0    3
9              U 	1.000000000    0    1    0
10    021    APU 	0.000000000    0    0    0
11            PU 	0.516260163    0    0    1
12             U 	0.483739837    0    2    0
13    022    APU 	0.000000000    0    0    0
14            PU 	0.243478261    0    0    2
15             U 	0.756521739    0    2    0
16    023    APU 	0.000000000    0    0    0
17            PU 	0.000000000    0    0    3
18             U 	1.000000000    0    2    0
19    031    APU 	0.000000000    0    0    0
20            PU 	0.723977965    0    0    1
21             U 	0.276022035    0    3    0
22    032    APU 	0.000000000    0    0    0
23            PU 	0.231192661    0    0    2
24             U 	0.768807339    0    3    0
...

```
