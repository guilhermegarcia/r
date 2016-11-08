uPoint = function(string, lexicon){

	subWd = list()

	for(i in rev(seq_along(str_split(string, "")[[1]]))){

	subWd[[length(subWd)+1]] = str_split(string, "")[[1]][-c(i:(length(str_split(string, "")[[1]]))+1)]

	}

	UPs = c()

	for(i in seq_along(subWd)){

			UPs[length(UPs)+1] = length(which(str_detect(lexicon, str_c(subWd[[i]], collapse = ""))))
	}

	UPs = rev(UPs)

	minimum = min(UPs)

	return(which(UPs == minimum)[1])

}


psc$proU[which(str_detect(psc$proU, "paralele"))]




test = psc[1:50,]


test$POU = NA


head(test)

for(i in 1:nrow(test)){

	test$POU[i] = uPoint(test$proU[i], test$proU)

}


psc$POU = NA

for(i in 1:nrow(psc)){

	psc$POU[i] = uPoint(psc$proU[i], psc$proU)
}
