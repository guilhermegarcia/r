# Word profiles

This very simple function ```profile()``` takes a string and returns its CV template. You can pre-specify the inventory (the example below also contains glides). This is the R version, but there's also a Python version in the Python repository.

## Example

```profile("bakaton")``` returns ```CVCVCVC```    

```profile("ba-ka-ton")``` returns ```CV.CV.CVC```   

Thus, you need to provide the syllabification in the input if you want it in the output.


```{R}

profile = function(word){


	vowels = c("a", "e", "i", "o", "u", "E", "O")

	glides = c("j", "w")

	consonants = c("b", "d", "f", "g", "k", "l", "L", "m", "n", "p", "r", "s", "S", "t", "v", "x", "z", "Z", "N", "L")

    
    output = ""

	word = strsplit(word, "")

    for(letter in word[[1]]){
        if(letter %in% consonants){
            output = paste(output, "C", sep = "")}
        else if(letter %in% glides){
            output = paste(output, "G", sep = "")}
        else if(letter %in% vowels){
            output = paste(output, "V", sep = "")}
        else{
            if(letter == "'"){
                output = paste(output, "", sep = "")}
            if(letter == "-"){
                output = paste(output, ".", sep = "")}}
    }
    return(output)
	
}	
	
    


```
