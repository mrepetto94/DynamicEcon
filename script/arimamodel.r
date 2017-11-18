#this script builds the arima models for the stocks provided by the stock.csv

library(forecast)
library(tseries)


stock <- read.table("stock.csv", dec = ",", sep = ";", header = 1)
#list <- colnames(stock)
#divide in training set and test set

train <- ts(stock[1:70,])
test <- ts(stock[71:100,], start = 71, end = 100)
l <- length(stock[1,])

fit <- lapply(train, auto.arima)
foreca <- lapply(fit, h = 30, level = 95, forecast)
fitted <- lapply(fit, fitted)

i <- 1
error <- test * 0
for (i in 1:l) {
	error [,i] <- foreca [[i]][[4]] - test [,i]
	print(i)
}

plot.ts(error)

### feed the residuals into a neural net
require("neuralnet")

f <- as.formula("AMTD ~ indice")
nn <- neuralnet(f,train,hidden=c(3,2), linear.output = FALSE)

plot(fitted$AMTD, col = "red")
lines(train[,1], col = "black")
lines(compute(nn,indice), col = "yellow")




