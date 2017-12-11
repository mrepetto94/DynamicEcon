#main script
#this script builds the arima models for a random stock in the portfolio
#and
#create a NN fed by the prices of the stock bucket to predict t+1 errror

library(forecast)
library(tseries)
library(neuralnet)

#set seed and choose a random stock to give into the ARIMA process
set.seed(60)
s <- sample(1:31, 1)

#get the stock value
stock <- read.table("stock.csv", dec = ",", sep = ";", header = 1)

#get training set
train <- ts(stock[1:60,s])

#fit model
fit <- auto.arima(train)

#get fitting error
error <- train * 0
error <- fit$fitted - train

#NN part
#get out the first error element
errortrim <- error[-c(1)]

#get a normalized dataframe of the stock price
scaled <-as.data.frame(scale(train))

names(scaled)[s] <- paste(names(train[s]), "error", sep = "")
train[s] <- as.numeric(as.character(unlist(error)))
n <- names(train)

#try to train a nnet on the stock's error using the prices of the other equity
y <- paste(n[s], "~")

f <- as.formula(paste(y, paste(n[!n %in% n[s]], collapse = " + ")))

nn <- neuralnet(f,data=train,hidden=c(16),linear.output=T)

#try to predict it 
foreca.nn <- compute(nn,stockscaled[60, -s])$net.result

#convert it to a strategy


#add the naive strategy
naive <- sample(c(0,1), replace=TRUE, size=length(strategy))


