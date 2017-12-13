#main script
#this script builds the arima models for a random stock in the portfolio
#and
#create a NN fed by the prices of the stock bucket to predict t+1 errror

library(forecast)
library(tseries)
library(neuralnet)
library(ggplot2)
library(ggpubr)

#set seed and choose a random stock to give into the ARIMA process
set.seed(60)
#s <- sample(1:31, 1)
s <- 1
model <- list()
naive <- list()
arima <- list()
name <- list()

confumodel <- vector(mode = "numeric", length = 931)
confunaive <- vector(mode = "numeric", length = 931)
confuarima <- vector(mode = "numeric", length = 931)
real <- vector(mode = "numeric", length = 931)

confumatrix <- data.frame(real,confumodel,confunaive,confuarima)
names(confumatrix) <- c("Real", "Model", "Naive","ARIMA")

#Start from the  first sixty data points
stockfull <- read.table("stock.csv", dec = ",", sep = ";", header = 1)

for (s in 1:length(stockfull)){
print(s)
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
  
  if (i!= 1){
    #bulding a confusion matrix process
    if (stock[59,s] < stock[60,s]){ 
      confumatrix$Real[(i+((s-1)*31))] <- 1 
      }
    #naive confusion matrix part
    confumatrix$Naive[(i+((s-1)*31))] <- signal.naive
    #ARIMA confusion matrix part
    confumatrix$ARIMA[(i+((s-1)*31))] <- signal.arima
    #Hybrid model confusion matrix part
    confumatrix$Model[(i+((s-1)*31))] <- signal.model
  }else{
    confumatrix$Real[(i+((s-1)*31))] <- NA
  #naive confusion matrix part
    confumatrix$Naive[(i+((s-1)*31))] <- NA
  #ARIMA confusion matrix part
    confumatrix$ARIMA[(i+((s-1)*31))] <- NA
  #Hybrid model confusion matrix part
    confumatrix$Model[(i+((s-1)*31))] <- NA
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

pldata <- data.frame(unlist(name),unlist(model),unlist(naive), unlist(arima))
names(pldata) <- c("Name", "Model", "Naive","ARIMA")

#confuion matrixes plot

Real <-      factor(c(0, 0, 1, 1))
Predicted <- factor(c(0, 1, 0, 1))

Y      <- c(sum((confumatrix$Real == 0) & (confumatrix$ARIMA == 0), na.rm=TRUE),
            sum((confumatrix$Real == 0) & (confumatrix$ARIMA == 1), na.rm=TRUE),
            sum((confumatrix$Real == 1) & (confumatrix$ARIMA == 0), na.rm=TRUE), 
            sum((confumatrix$Real == 1) & (confumatrix$ARIMA == 1), na.rm=TRUE))
df <- data.frame(Real, Predicted, Y)

p2 <-ggplot(data =  df, mapping = aes(x = Real, y = Predicted)) +
  geom_tile(aes(fill = Y), colour = "white") +
  geom_text(aes(label = sprintf("%1.0f", Y)), vjust = 1) +
  scale_fill_gradient(low = "white", high = "grey") +
  theme_bw() + theme(legend.position = "none") +
  labs(title = "ARIMA")

Y      <- c(sum((confumatrix$Real == 0) & (confumatrix$Naive == 0), na.rm=TRUE),
            sum((confumatrix$Real == 0) & (confumatrix$Naive == 1), na.rm=TRUE),
            sum((confumatrix$Real == 1) & (confumatrix$Naive == 0), na.rm=TRUE), 
            sum((confumatrix$Real == 1) & (confumatrix$Naive == 1), na.rm=TRUE))
df <- data.frame(Real, Predicted, Y)

p1 <-ggplot(data =  df, mapping = aes(x = Real, y = Predicted)) +
  geom_tile(aes(fill = Y), colour = "white") +
  geom_text(aes(label = sprintf("%1.0f", Y)), vjust = 1) +
  scale_fill_gradient(low = "white", high = "grey") +
  theme_bw() + theme(legend.position = "none") +
  labs(title = "Naive")

Y      <- c(sum((confumatrix$Real == 0) & (confumatrix$Model == 0), na.rm=TRUE),
            sum((confumatrix$Real == 0) & (confumatrix$Model == 1), na.rm=TRUE),
            sum((confumatrix$Real == 1) & (confumatrix$Model == 0), na.rm=TRUE), 
            sum((confumatrix$Real == 1) & (confumatrix$Model == 1), na.rm=TRUE))
df <- data.frame(Real, Predicted, Y)

p3 <-ggplot(data =  df, mapping = aes(x = Real, y = Predicted)) +
  geom_tile(aes(fill = Y), colour = "white") +
  geom_text(aes(label = sprintf("%1.0f", Y)), vjust = 1) +
  scale_fill_gradient(low = "white", high = "grey") +
  theme_bw() + theme(legend.position = "none") +
  labs(title = "Hybrid ARIMA")

ggarrange(p1, p2, p3,
          ncol = 3, nrow = 1)



