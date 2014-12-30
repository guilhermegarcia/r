## Plotting distributions

This script has one simple function, ```dPlot()```, which plots some common distributions using ```ggplot2```. These are
the available distributions:

* ```normal```
* ```bimodal```
* ```f```
* ```j``` (j-shaped)
* ```log```
* ```cdf``` (cumulative distribution function)
* ```u``` (u-shaped)

### How to use the function

Simply type ```dPlot()``` and use one of the available distributions. Download the script [here](http://guilhermegarcia.github.io/resources/scripts/dPlot.R) or use it via source:  

```{r}
source('http://guilhermegarcia.github.io/resources/scripts/dPlot.R'
```

The main objective here is to quickly generate plots for stats-related handouts/slides, for example, so you can modify the function to create any given distribution you'd like.

----

```{r}


require(ggplot2)
require(boot)

cat('\n\nTypes of distributions available: bimodal, normal, f, j, log, cdf, u. \nSimply type dPlot() and add the distribution needed.\n\n Copyright (c) 2014 Guilherme Duarte Garcia\n\n\n')

dPlot = function(d=c('bimodal, normal, f, j, log, cdf, u')){

d = as.character(substitute(d))


if(!d %in% c('bimodal', 'normal', 'f', 'j', 'log', 'cdf', 'u')){stop(print('This is not a valid input'))}

if(tolower(d) == 'normal'){

normal = data.frame(item=rnorm(100000,mean=0,sd=1))

normal.plot = ggplot(data=normal, aes(x=item)) + stat_function(fun=dnorm) + theme_bw() + theme(text=element_text(size=15, vjust=1)) + ggtitle("Normal Distribution") + ylab(NULL) + xlab(NULL)

return(normal.plot)

} else if(tolower(d) == 'j'){

j.plot = ggplot(data.frame(j=c(0,5)), aes(x=j)) + stat_function(fun=exp) + theme_bw() + theme(text=element_text(size=15, vjust=1)) + ggtitle("J-shaped Distribution") + ylab(NULL) + xlab(NULL)

return(j.plot)

} else if(tolower(d) == 'log'){


log.plot = ggplot(data.frame(j=c(1,100)), aes(x=j)) + stat_function(fun=log) + theme_bw() + theme(text=element_text(size=15, vjust=1)) + ggtitle("Log Distribution") + ylab(NULL) + xlab(NULL)

return(log.plot)

} else if(tolower(d) == 'bimodal'){


bimodal.plot = ggplot(data.frame(j=c(-10,10)), aes(x=j)) + stat_function(fun=function(x)(dnorm(x,mean=5,sd=2)+dnorm(x,mean=-5,sd=2))) + theme_bw() + theme(text=element_text(size=15, vjust=1)) + ggtitle("Bimodal Distribution") + ylab(NULL) + xlab(NULL)


return(bimodal.plot)

} else if(tolower(d) == 'f'){

f.plot = ggplot(data.frame(j=c(0,10)), aes(x=j)) + stat_function(fun=function(x)(df(x,df1=10,df2=10))) + theme_bw() + theme(text=element_text(size=15, vjust=1)) + ggtitle("F Distribution") + ylab(NULL) + xlab(NULL)


return(f.plot)

} else if(tolower(d) == 'u'){

u.plot = ggplot(data.frame(j=c(-10,10)), aes(x=j)) + stat_function(fun=function(x)(-dnorm(x,mean=0,sd=3)))  + theme_bw() + theme(text=element_text(size=15, vjust=1)) + ggtitle("U-shaped Distribution") + ylab(NULL) + xlab(NULL)

return(u.plot)

}

}

```
