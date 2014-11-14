## Plotting random effects/slopes

*Guilherme D. Garcia (McGill)*

This is a basic function, so you can build on / adapt it. The two arguments you'll need are (1) a mixed model object 
(```glmer()``` in R) and (2) the random effect included in the model. If your model 'mod1' includes an 'item' random 
effect, then the arguments are <mod1,item>.

The function returns a plot that shows the different random effects (```y=value, x=response```). Make sure to check how the
function actually fits the way your data (and model) are organized. This is only a **template**.


```{R}
plotRand <- function(model,reffect){

	require(reshape2)
	require(ggplot2)	
	
	if(class(model) != 'glmerMod'){
		stop('Your input does not contain random effects')
	} else {
		
		x <- ranef(model)[as.character(substitute(reffect))][[1]][[1]]
		y <- ranef(model)[as.character(substitute(reffect))][[1]][[2]]
		
		rand <- data.frame(x,y)
		
		rand['item'] <- seq(1:nrow(rand))
		
		effects <- melt(rand, id.vars=c('item'))
		
		names(effects) <- c('item', 'response', 'value')
		
		plot <- ggplot(data=effects, aes(x=response, y=value)) + 
		geom_line(aes(group=factor(as.character(substitute(item))))) + theme_bw() + 
		theme(legend.position="None")
		
		return(plot)
		}
}
```
