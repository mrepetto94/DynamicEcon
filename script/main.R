#main script

require(alphavantager)

av_api_key("JJQ9PELUQJJ2FQ0U")

readSym <- function(sym) {
    out <- tryCatch(
        {
            av_get(symbol = sym, av_fun = "TIME_SERIES_INTRADAY", interval = "1min") 
        },
        error=function(cond) {
            message(paste("URL does not seem to exist:", sym))
            return(NA)
        },
        warning=function(cond) {
            message(paste("URL caused a warning:", sym))
            return(NULL)
        },
        finally={ 
            message(paste("Processed URL:", sym))
        }
    )    
    return(out)
}

list <- source("nasdaqlisted.R")
list <- list$value

list <- sample(list, 2)

sapply(list, readSym)

