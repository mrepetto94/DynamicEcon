#this script builds the arima models for the stocks provided by the stock.csv

library(forecast)
library(tseries)


stock <- read.table("stock.csv", dec = ",", sep = ";", header = 1)

l <- length(stock[1,])

stock<- ts(stock)

fit <- lapply(stock, auto.arima)
foreca <- lapply(fit, forecast)

f=c(1:l)

i=1
for(i in 1:l){
	
f[i] <- foreca[[i]][[4]][[1]]
	
}

f-stock[100,]

