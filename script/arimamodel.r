#this script builds the arima models for the stocks provided by the stock.csv

library(forecast)
library(tseries)


stock <- read.table("stock.csv", dec = ",", sep = ";", header = 1)
#list <- colnames(stock)

#divide in training set and test set

train <- ts(stock[1:99,])
test <- ts(stock[99:100,], start = 99, end = 100)
l <- length(stock[1,])

fit <- lapply(train, auto.arima)
foreca <- lapply(fit, h = 1, level = 95, forecast)
fitted <- lapply(fit, fitted)

i <- 1
error <- train * 0
for (i in 1:l) {
	error [,i] <- fitted [[i]] - train [,i]
	foreca[i] <- foreca[[i]]$mean[1]
	}

foreca <- as.data.frame(foreca)

write.table(error, file = "error.csv", dec=",", sep = ";", row.names = FALSE)
write.table(foreca, file = "foreca.csv", dec=",", sep = ";", row.names = FALSE)

