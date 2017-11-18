#a script in case of plot

data <- read.table("stock.csv", dec = ",", sep = ";", header = TRUE)
plot.ts(data)
