#This script return the symbol of NASDAQ listed companies
#load the necessary libraries
require(RCurl)


#searching for the NASDAQ listed companies
txt=getURL("ftp://nasdaqtrader.com/SymbolDirectory/Nasdaqlisted.txt", ssl.verifypeer = FALSE)

#create a data frame out of that
listdata = read.table(textConnection(txt), header = TRUE, sep = "|", dec = "\n" )

#take only the common stocks
#for cycle
liststock <- listdata[,1]

	
n <- grep("Common Stock", listdata$Security.Name)
liststock <- liststock[n]

#create an array of symbols
symbols = as.character(liststock)

#eliminate the last element (data update blah)
symbols <- head(symbols, -2)

write.table(symbols, file = "listedCS.csv", sep = ";")

