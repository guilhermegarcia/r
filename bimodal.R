# This generates two normal distributions, so you can easily generate a binomial distribution (see example at the end).

bimodal = function(n, mean1, sd1, mean2, sd2){
	
	# n = The number of observations
	
	require(ggplot2)
	
	x = rnorm(n, mean=mean1, sd=sd1)
	y = rnorm(n, mean=mean2, sd=sd2)
	z = data.frame(Data=c(x,y), someFactor=gl(1,n*2,n*2, labels=c('level')))
	
	ggplot(data=z, aes(x=Data)) + geom_histogram(binwidth=0.05, alpha=0.5, fill="black") + theme_bw() + labs(y="", x="") + ggtitle("Bimodal distribution\n") + theme(text=element_text(size=15))
	
}

# Example:

bimodal(n=1000, mean1=0, sd1=0.5, mean2=3, sd2=0.5)
