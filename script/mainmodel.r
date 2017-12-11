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

#Start from the  first sixty data points
stockfull <- read.table("stock.csv", dec = ",", sep = ";", header = 1)

i <- 1
buy <- FALSE
#starting a loop that will loop 30 times
for (i in 1:30){

  print("starting round")
  print(i)
  
  stock <- stockfull[i:(i+59),]
  
  if (i != 1){
    # buying side
    if (buy == TRUE){
      if pred 
    }
    # selling side
  }
  
  
  
  
  #get training set
  train <- ts(stock[,s])
  
  #fit model
  fit <- auto.arima(train)

  #get fitting error
  error <- train * 0
  error <- fit$fitted - train

  #NN part
  #get out the first error element a last element of train
  error.trim <- error[-c(1)]
  stock.trim <- stock[-c(length(train)),]

  #get a normalized dataframe of the stock price
  scaled <-as.data.frame(scale(stock))
  scaled.trim <-as.data.frame(scale(stock.trim))

  scaled.trim[s] <- as.numeric(as.character(unlist(error.trim)))
  n <- names(scaled)

  #try to train a nnet on the stock's error using the prices of the other equity
  y <- paste(n[s], "~")
  f <- as.formula(paste(y, paste(n[!n %in% n[s]], collapse = " + ")))

  nn <- neuralnet(f,data=scaled.trim,hidden=c(20),linear.output=T)

  #adjust ARIMA prediction
  foreca <- forecast(fit, h = 1)
  pred <- as.numeric(compute(nn,scaled[60, -s])$net.result) + as.numeric(foreca$mean)
  
  #convert prediction to signal
  signal.model <- 0
  if (pred > stock[60,s]){
    signal.model <- 1
  }
  signal.naive <- sample(c(0,1), replace=TRUE, size=1)
  
}
