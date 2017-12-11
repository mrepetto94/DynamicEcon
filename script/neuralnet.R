#this script creates a neural net that tryies to interpret the error of the arima model given the lagged value of the stocks analyzed
library(neuralnet)

#get the data
stock <- read.table("stock.csv", dec = ",", sep = ";", header = 1)
error <- read.table("error.csv", dec = ",", sep = ";", header = 1)

#set seed and choose a random stock to give into the ARIMA process
set.seed(60)
s <- sample(1:31, 1)

#get out the first error element
errortrim <- error[-c(1),]

#get a normalized dataframe of the stock price
stockscaled <-as.data.frame(scale(stock))

train <- stockscaled[1:60,]
names(train)[s] <- paste(names(train[s]), "error", sep = "")
train[s] <- as.numeric(as.character(unlist(error)))
n <- names(train)

#try to train a nnet on the stock's error using the prices of the other equity
y <- paste(n[s], "~")
f <- as.formula(paste(y, paste(n[!n %in% n[s]], collapse = " + ")))
nn <- neuralnet(f,data=train,hidden=c(16),linear.output=T)

names(nn) <- names(stock)

#try to predict it 
  perror <- compute(nn,stockscaled[58, -s])$net.result

names(perrors) <- names(stock)

foreca1 <- foreca + perrors
foreca1 <- foreca1 - stock[99,]

#convert it to a strategy
strategy <- as.data.frame(apply(foreca1, 2, function(x){ifelse(any(x <= 0), 0, 1)}))

#add the naive strategy

naive <- sample(c(0,1), replace=TRUE, size=length(strategy))
strategy <- cbind(strategy,naive)

write.table(strategy, file = "strategy.csv", dec=",", sep = ";", row.names = FALSE)
