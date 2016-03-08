# Pseudo randomization

This function (```rand()```) pseudo randomizes a data frame taking into account a particular factor of interest. For example, let's say you want to randomize all rows in the data frame but you do not want to have too long sequences of items that happen to have the same level of a factor you're interested in. That's the purpose of ```rand()```.

The function takes three arguments: a data frame ```d```, a variable ```v``` and an optional cut-off point ```n``` (default = ```3```). The function then randomizes the data frame and checks if there's any sequence of ```n``` instances of any level of ```v``` in the randomized version of the data frame. If there is, another randomization is performed until the cut-off point is satisfied. Because this is a ```while``` loop and we don't want to get stuck, a stopping point is enforced by the number of iterations (set to ```10000``` here). If that's the case, an error is printed. Naturally, depending of the number of levels of ```v```, the number of rows of ```d``` and ```n```, no randomization will satisfy the cut-off point.


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
