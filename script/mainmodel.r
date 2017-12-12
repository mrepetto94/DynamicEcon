#main script
#this script builds the arima models for a random stock in the portfolio
#and
#create a NN fed by the prices of the stock bucket to predict t+1 errror

library(forecast)
library(tseries)
library(neuralnet)

#set seed and choose a random stock to give into the ARIMA process
set.seed(60)
#s <- sample(1:31, 1)
s <- 1
model <- list()
naive <- list()
arima <- list()
name <- list()

confumodel <- list()
confunaive <- list()
confuarima <- list()
real <- list()

#Start from the  first sixty data points
stockfull <- read.table("stock.csv", dec = ",", sep = ";", header = 1)

for (s in 1:31){

i <- 1

buy.model <- FALSE
buy.naive <- FALSE
buy.arima <- FALSE

profitloss.model <- 0
profitloss.naive <- 0
profitloss.arima <- 0

buyprice.model <- 0
buyprice.naive <- 0
buyprice.arima <- 0

#starting a loop that will loop 30 times
for (i in 1:30){
  
  stock <- stockfull[i:(i+59),]
  
  if (i!=1){
    #bulding a confusion matrix process
    if (stock[59,s] < stock[60,s]){ real[(i+(s*31))-1] <- 1 }
    #naive confusion matrix part
    confunaive[(i+(s*31))-1] <- signal.naive
    #ARIMA confusion matrix part
    confunaive[(i+(s*31))-1] <- signal.arima
    #Hybrid model confusion matrix part
    confunaive[(i+(s*31))-1] <- signal.model
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
  signal.arima <- 0
  
  if (pred > stock[60,s]){
    signal.model <- 1
  }
  
  if (as.numeric(foreca$mean) > stock[60,s]){
    signal.arima <- 1
  }
  
  signal.naive <- sample(c(0,1), replace=TRUE, size=1)
  
  
  if (i != 30){
    # buying selling side model  
    if (buy.model == TRUE){
      if (signal.model < 1){
        profitloss.model <- profitloss.model + (buyprice.model - stock[60,s])
        buy.model = FALSE
      }
    }else{
      if (signal.model == 1){
        buyprice.model <- stock[60,s]
        buy.model = TRUE
        }
    }
    
    # buying selling side plain ARIMA  
    if (buy.arima == TRUE){
      if (signal.model < 1){
        profitloss.arima <- profitloss.arima + (buyprice.arima - stock[60,s])
        buy.arima = FALSE
      }
    }else{
      if (signal.arima == 1){
        buyprice.arima <- stock[60,s]
        buy.arima = TRUE
      }
    }

  # buying selling side naive
      if (buy.naive == TRUE){
        if (signal.naive < 1){
          profitloss.naive <- profitloss.naive + (buyprice.naive - stock[60,s])
          buy.naive = FALSE
        }
      }else{
        if (signal.naive == 1){
          buyprice.naive <- stock[60,s]
          buy.naive = TRUE
        }
      }
  }

}

#deposit the overall profit and loss
model[s] <- profitloss.model
naive[s] <- profitloss.naive
arima[s] <- profitloss.arima
name[s]  <- names(stockfull)[s]

}

confumatrix <- data.frame(unlist(name),unlist(real),unlist(confumodel),unlist(confunaive),unlist(confuarima))
pldata <- data.frame(unlist(name),unlist(model),unlist(naive), unlist(arima))
names(pldata) <- c("Name", "Model", "Naive","ARIMA")
names(confumatrix) <- c("Name","Real", "Model", "Naive","ARIMA")



