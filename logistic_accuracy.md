## How accurate is your logistic (binomial/ordinal) model?

*Guilherme D. Garcia (McGill)*

After you've explored important aspects of your models (AIC, significances, slopes, residuals, diagnostic plots, ```anova()``` etc.), you might want to have a rough estimate of the model's accuracy, that is, what percentage of the data is correctly predicted (assuming correct = ```>.5```, see below—this is done manually for binomial models in the function). This *approximation* tends to be fairly intuitive to readers (more so than, say, log-odds and predicted probabilities for a given data point assuming multiple coefficients). 

This function takes **five** or **four** arguments (in this order), depending on which model you're evaluating: a binomial or an ordinal logistic model (```glm()``` or ```glmer()```; ```clm()```), the type of model you're using (```type='binomial'``` or ```type='ordinal'```) a data file,
a response variable (which **needs to be a factor**, of course), and, in case ```type='binomial'```, a reference value for your binary response. As you can see, the function takes these arguments and creates a ```data.frame``` where predicted probabilities are compared to actual values. The assumption for binomial models here is: in a model with responses ```x``` and ```y```, where ```x``` is the reference level, whenever the predicted probability is ```>.5```, the function assumes ```x```. Now that probabilities are categorical (binary) responses, actual and predicted values can be compared. The final percentage comes from a simple ```xtabs```. Note that there's no ```stop()``` in the function, so make sure all arguments are correct.


```{R}
accuracy <- function(model,type=c('binomial', 'ordinal'),data,response,value){
	
	if(type=='binomial'){
	
	actual <- data[[as.character(substitute(response))]]
	
	preds <- data.frame(predict(model, type='response'))
	
	acc <- data.frame(actual,preds=preds)
	
	names(acc) <- c('actual', 'preds')
	
	acc['real'] <- ifelse(acc$actual == as.character(substitute(value)),1,0)
	acc['pred'] <- ifelse(acc$preds > 0.5, 1, 0)
	
	new_acc <- subset(acc, select=c('real', 'pred'))
	new_acc['so'] <- ifelse(new_acc$real == new_acc$pred,1,0)
	
	outcome <- prop.table(xtabs(~so,new_acc))

	return(cat("Model's accuracy is ", round(outcome[[2]]*100,2), "%", sep=""))
	} else if(type=='ordinal'){
		
	actual <- data[[as.character(substitute(response))]]
	
	preds <- data.frame(predict(model, type='class'))
	
	acc <- data.frame(actual,preds=preds)
	names(acc) <- c('actual', 'preds')
	
	acc['real'] <- factor(acc$actual, ordered=FALSE)
		
	acc['match'] <- ifelse(acc$real==acc$preds, 1, 0)
	
	acc.ord <- data.frame(prop.table(xtabs(~match,acc)))
	
	return(cat("Model's accuracy is ", round(acc.ord[[2]][2]*100,2), "%", sep=""))			
	} else {
		return("No accuracy has been computed. Only ordinal and binomial models can be evaluated.")
	}
	}
```
