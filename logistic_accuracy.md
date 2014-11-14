## How accurate is your logistic model?

*Guilherme D. Garcia (McGill)*

After you've explored important aspects of your models (AIC, significances, slopes, residuals, diagnostic plots, ```anova()``` etc.), you might want to have a rough estimate of the model's accuracy, that is, what percentage of the data is correctly predicted (see below). This *approximation* tends to be fairly intuitive to readers (than, say, log-odds and predicted probabilities for a given data point assuming multiple coefficients). 

This function takes **four** arguments (in this order): a logistic model (```glm()``` or ```glmer()```), a data file,
a response variable (which **needs to be a factor**, of course), and a reference value for your response. As you can see, the
function takes these arguments and creates a ```data.frame``` where predicted probabilities are compared to actual values. The
assumption here is: in a binomial model with responses ```x``` and ```y```, where ```x``` is the reference level, whenever
the predicted probability is ```>.5```, the function assumes ```x```. Now that probabilities are categorical (binary) responses,
actual and predicted values can be compared. The final percentage comes from a simple ```xtabs```. Note that there's no ```stop()``` in the function, so make sure all arguments are correct.


```{R}
accuracy <- function(model,data,response,value){
	
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
}
```
