#main script

require(quantmod)

set.seed(60)

##function Read sym##

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

## end of function read sym ##

list <- read.table("listedCS.csv", sep = ";")
list <- as.character(list[,1])

list <- sample(list, 10)
#list <- list[6:15]

stock <- sapply(list, readSym)

stock <-as.data.frame(stock)

write.table(stock, file = "stock.csv", dec=",", sep = ";", row.names = FALSE)



