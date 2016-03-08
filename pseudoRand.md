# Pseudo randomization

This function (```rand()```).


```{r}

rand = function(dataframe, var, cut=3){
  
  output = dataframe
  temp  = rle(as.character(output[,as.character(substitute(var))]))$lengths

  iterations = 0
  
  while(length(which(temp >= cut)) > 0){
    
    output$random = rnorm(nrow(output))
    output = arrange(output, random)
    
    temp = rle(as.character(output[,as.character(substitute(var))]))$lengths
    
    output = select(output, -random)
    
    iterations = iterations + 1
    
    if(iterations == 10000){
      stop("No output after 100 iterations.")
    }
         
  }
  
  return(output)
  
}



```
