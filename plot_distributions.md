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
* ```chi``` (Chi-square)

### How to use the function

Simply type ```dPlot()``` and use one of the available distributions. Download the script [here](http://guilhermegarcia.github.io/resources/scripts/dPlot.R) or use it via source:  

```{r}
source('http://guilhermegarcia.github.io/resources/scripts/dPlot.R')
```

The main objective here is to quickly generate plots for stats-related handouts/slides, for example, so you can modify the function to create any given distribution you'd like.

----

```{r}



require(ggplot2)
require(boot)

cat('\n\nTypes of distributions available: bimodal, normal, f, j, log, cdf, u, chi. 
Simply type dPlot() and add the distribution needed.\n\nCopyright (c) 2014 Guilherme Duarte Garcia\n\n\n')

dPlot = function(d=c('bimodal', 'normal', 'f', 'j', 'log', 'cdf', 'u')){

d = as.character(substitute(d))

d = tolower(d)


if(!d %in% c('bimodal', 'normal', 'f', 'j', 'log', 'cdf', 'u', 'chi')){stop('This is not a valid input')}

if(tolower(d) == 'normal'){

normal.plot = ggplot(data.frame(j=c(-10,10)), aes(x=j)) + stat_function(fun=function(x)(dnorm(x,mean=0,sd=2))) + theme_bw() + theme(text=element_text(size=15, vjust=1)) + ggtitle("Normal Distribution") + ylab(NULL) + xlab(NULL)

return(normal.plot)

} else if(tolower(d) == 'j'){

j.plot = ggplot(data.frame(j=c(0,5)), aes(x=j)) + stat_function(fun=exp) + theme_bw() + theme(text=element_text(size=15, vjust=1)) + ggtitle("J-shaped Distribution") + ylab(NULL) + xlab(NULL)

return(j.plot)

} else if(tolower(d) == 'log'){


log.plot = ggplot(data.frame(j=c(1,100)), aes(x=j)) + stat_function(fun=log) + theme_bw() + theme(text=element_text(size=15, vjust=1)) + ggtitle("Log Distribution") + ylab(NULL) + xlab(NULL)

return(log.plot)

} else if(tolower(d) == 'bimodal'){


bimodal.plot = ggplot(data.frame(j=c(-10,10)), aes(x=j)) + stat_function(fun=function(x){dnorm(x,mean=5,sd=2)+dnorm(x,mean=-5,sd=2)}) + theme_bw() + theme(text=element_text(size=15, vjust=1)) + ggtitle("Bimodal Distribution") + ylab(NULL) + xlab(NULL)


return(bimodal.plot)

} else if(tolower(d) == 'f'){

f.plot = ggplot(data.frame(j=c(0,10)), aes(x=j)) + stat_function(fun=function(x){df(x,df1=10,df2=10)}) + theme_bw() + theme(text=element_text(size=15, vjust=1)) + ggtitle("F Distribution") + ylab(NULL) + xlab(NULL)


return(f.plot)

} else if(tolower(d) == 'u'){

u.plot = ggplot(data.frame(j=c(-10,10)), aes(x=j)) + stat_function(fun=function(x){-dnorm(x,mean=0,sd=3)})  + theme_bw() + theme(text=element_text(size=15, vjust=1)) + ggtitle("U-shaped Distribution") + ylab(NULL) + xlab(NULL)

return(u.plot)

} else if(tolower(d) == 'cdf'){
	
cdf.plot = ggplot(data.frame(j=c(-10,10)), aes(x=j)) + stat_function(fun=inv.logit) + theme_bw() + theme(text=element_text(size=15, vjust=1)) + ggtitle("Cumulative Distribution") + ylab(NULL) + xlab(NULL)
	
return(cdf.plot)

} else if(tolower(d) == 'chi'){

chi.plot = ggplot(data.frame(j=c(0,20)), aes(x=j)) + stat_function(fun=function(x){dchisq(x, 5, ncp = 0, log = FALSE)}) + theme_bw() + theme(text=element_text(size=15, vjust=1)) + ggtitle(expression(paste(chi^2, " Distribution"))) + ylab(NULL) + xlab(NULL)
	
return(chi.plot)
	
}

}


```
