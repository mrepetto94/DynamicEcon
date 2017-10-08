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
	add_trace(y = ~data[,10], name = trace[10], mode = 'lines') %>%
	add_trace(y = ~data[,11], name = trace[11], mode = 'lines') %>%
	add_trace(y = ~data[,12], name = trace[12], mode = 'lines') %>%
	add_trace(y = ~data[,13], name = trace[13], mode = 'lines') %>%
	add_trace(y = ~data[,14], name = trace[14], mode = 'lines') %>%
	add_trace(y = ~data[,15], name = trace[15], mode = 'lines') %>%
	add_trace(y = ~data[,16], name = trace[16], mode = 'lines') %>%
	add_trace(y = ~data[,17], name = trace[17], mode = 'lines') %>%
	add_trace(y = ~data[,18], name = trace[18], mode = 'lines') %>%
	add_trace(y = ~data[,19], name = trace[19], mode = 'lines') %>%
	add_trace(y = ~data[,20], name = trace[20], mode = 'lines') %>%
	add_trace(y = ~data[,21], name = trace[21], mode = 'lines') %>%
	add_trace(y = ~data[,22], name = trace[22], mode = 'lines') %>%
	add_trace(y = ~data[,23], name = trace[23], mode = 'lines') %>%
	add_trace(y = ~data[,24], name = trace[24], mode = 'lines') %>%
	add_trace(y = ~data[,25], name = trace[25], mode = 'lines') %>%
	add_trace(y = ~data[,26], name = trace[26], mode = 'lines') %>%
	add_trace(y = ~data[,27], name = trace[27], mode = 'lines') %>%
	add_trace(y = ~data[,28], name = trace[28], mode = 'lines') %>%
	add_trace(y = ~data[,29], name = trace[29], mode = 'lines') %>%
	add_trace(y = ~data[,30], name = trace[30], mode = 'lines') %>%
	add_trace(y = ~data[,31], name = trace[31], mode = 'lines') %>%
	add_trace(y = ~data[,32], name = trace[32], mode = 'lines') %>%
	add_trace(y = ~data[,33], name = trace[33], mode = 'lines') %>%
	add_trace(y = ~data[,34], name = trace[34], mode = 'lines')



























plotly_IMAGE(p, out_file = "plotly-test-image.png")
