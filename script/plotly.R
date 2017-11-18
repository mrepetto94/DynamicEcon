#a script in case of plot

library(plotly)
Sys.setenv("plotly_username" = "mrepetto94")
Sys.setenv("plotly_api_key" = "s73bTthsx2qtjgoCqYEu")

data <- read.table("stock.csv", dec = ",", sep = ";", header = TRUE)
trace <- names(data)
data <- log(data)

x<-c(0:99)

p <- plot_ly(data = data, x = ~x, y = ~data[,1], name = trace[1] , type = "scatter", mode = "lines") %>%
	add_trace(y = ~data[,2], name = trace[2], mode = 'lines') %>%
	add_trace(y = ~data[,3], name = trace[3], mode = 'lines') %>%
	add_trace(y = ~data[,4], name = trace[4], mode = 'lines') %>%
	add_trace(y = ~data[,5], name = trace[5], mode = 'lines') %>%
	add_trace(y = ~data[,6], name = trace[6], mode = 'lines') %>%
	add_trace(y = ~data[,7], name = trace[7], mode = 'lines') %>%
	add_trace(y = ~data[,8], name = trace[8], mode = 'lines') %>%
	add_trace(y = ~data[,9], name = trace[9], mode = 'lines') %>%
	add_trace(y = ~data[,10], name = trace[10], mode = 'lines') 
	



























plotly_IMAGE(p, out_file = "plotly-test-image.png")
