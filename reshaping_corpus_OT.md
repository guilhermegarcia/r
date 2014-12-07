# Reshaping a dataset for OT-ish applications

This function is very specific, as I needed to turn a data frame into a list of unique combinations of variables,
include proportions, constraints, and assign violation marks. I used this for my 2014 paper on Gradient weight and stress,
where I propose an interval-based approach to stress in Portuguese. Because I wanted to map my analysis into a MaxEnt grammar
(Hayes & Wilson 2008), I needed the data to be in a specific format (see below).

## Summary: from A to B

My data looked like ```A``` below, and I needed something like ```B```. In ```A```, there are four columns. Each row is a
word in the lexicon. The first three columns tell you how many segments there are in all three intervals (see Steriade 2012)
in the stress domain (n=3). The fourth column tells you what is the stress in the word: final = ```1```, penult = ```2``` and
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

