#this script builds the arima models for a random stock in the portfolio

library(forecast)
library(tseries)

#get the stock value
stock <- read.table("stock.csv", dec = ",", sep = ";", header = 1)

#set seed and choose a random stock to give into the ARIMA process
set.seed(60)
s <- sample(1:31, 1)

#get training set
train <- ts(stock[1:60,s])

#fit model
fit <- auto.arima(train)

#get fitting error
error <- train * 0
error <- fit$fitted - train


write.table(error, file = "error.csv", dec=",", sep = ";", row.names = FALSE)


