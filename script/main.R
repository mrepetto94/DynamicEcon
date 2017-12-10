#main script

require(alphavantager)

av_api_key(Sys.getenv("Alpha_key"))

set.seed(60)

readSym <- function(sym) {
    out <- tryCatch(
        {
         x <- av_get(symbol = sym, av_fun = "TIME_SERIES_INTRADAY", interval = "1min") 
	if(length(x$close) == 100){
    	return(x$close)
	}else{
	return(NA)

	}
	},
        error=function(cond) {
            message(paste("URL does not seem to exist:", sym))
            return(NA)
        },
        warning=function(cond) {
            message(paste("URL caused a warning:", sym))
            return(NA)
        },
        finally={ 
            message(paste("Processed URL:", sym))
        }
    )    
return(out)

}

list <- read.table("listedCS.csv", sep = ";")
list <- as.character(list[,1])

#just to let the first warning go away
f <- av_get(symbol = list[1], av_fun = "TIME_SERIES_INTRADAY", interval = "1min") 

list <- sample(list, 34)

stock <- sapply(list, readSym)

stock <-as.data.frame(stock)
stock <- stock[colSums(!is.na(stock)) > 0]

#ts transformation
tsstock <- ts(stock[1:60,])

#plot of three samples
autoplot(tsstock[,sample(1:30, 3)])

write.table(stock, file = "stock.csv", dec=",", sep = ";", row.names = FALSE)



