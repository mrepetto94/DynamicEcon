#this script creates a neural net that tryies to interpret the error of the arima model given the lagged value of the stocks analyzed

library(neuralnet)

stock <- read.table("stock.csv", dec = ",", sep = ";", header = 1)
error <- read.table("error.csv", dec = ",", sep = ";", header = 1)
foreca <- read.table("foreca.csv", dec = ",", sep = ";", header = 1)

#get out the first error element
errortrim <- error[-c(1),]

#get a normalized dataframe of the stock price
stockscaled <-as.data.frame(scale(stock))

train <- stockscaled[1:98,]
i <- 0
n <- names(train)
nn <- list()

#try to train a nnet on the stock's error using the prices of the others

for (i in 1:length(stock)){
y <- paste(n[i], "~")
f <- as.formula(paste(y, paste(n[!n %in% n[i]], collapse = " + ")))
nn[[i]]<- neuralnet(f,data=train,hidden=c(16),linear.output=T)
}
names(nn) <- names(stock)

i <- 0

#try to predict it 
for (i in 1:length(stock)){
  perrors[i] <- as.data.frame(compute(nn[[i]],stockscaled[99, -c(i)])$net.result)
}
names(perrors) <- names(stock)

foreca1 <- foreca + perrors
foreca1 <- foreca1 - stock[99,]

#convert it to a strategy
strategy <- as.data.frame(apply(foreca1, 2, function(x){ifelse(any(x <= 0), 0, 1)}))

#add the naive strategy

naive <- sample(c(0,1), replace=TRUE, size=length(strategy))
strategy <- cbind(strategy,naive)

write.table(strategy, file = "strategy.csv", dec=",", sep = ";", row.names = FALSE)
