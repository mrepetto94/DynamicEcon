#This script return the symbol of NASDAQ listed companies
#load the necessary libraries
require(RCurl)

#function enunciation
commonstock <- function(secname){
return(grep("Common Stock", secname))
}

#searching for the NASDAQ listed companies
txt=getURL("ftp://nasdaqtrader.com/SymbolDirectory/Nasdaqlisted.txt", ssl.verifypeer = FALSE)

#create a data frame out of that
listdata = read.table(textConnection(txt), header = TRUE, sep = "|", dec = "\n" )

#take only the common stocks
#for cycle
liststock <- data.frame(listdata[0,])
#k=1
#i=1
#for(i in 1:(length(listdata$Security.Name))){
#	
#	if ((length(grep("Common Stock", listdata$Security.Name[i]))) == 1){
#		
#		liststock[k,] = listdata[i,]
#		k = k + 1
#	}
#}

lapply(listdata$Security.Name, commonstock)

#create an array of symbols
#symbols = as.character(liststock$Symbol)

#eliminate the last element (data update blah)
#symbols <- head(symbols, -2)


