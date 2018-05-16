# DynamicEcon
A project on Dynamic Econometrics.
The paper proposes a hybrid combination of ARIMA process and ANN in order to perform equity trading. Transaction costs were not taken into account.

## In brief
ARIMA processes are a class of univariate time series models, this kind of models attempt to predict financial variables using only information contained in their own past values and possibly current and past values of an error term. ARIMA process differs from the exponential smoothing since ARIMA focuses on the autocorrelation of the time series instead of trend and seasonality. Such model firstly proposed by Box-Jenkins combines three factors, namely: differencing, autoregressive model and moving average model.

Where differencing is intend as the process of transformation of the time series such that we end up with a stationary time series which has as main property no time dependency, in other terms given <img src="/tex/a918cf04cd0ac7535e7626be634cfb9e.svg?invert_in_darkmode&sanitize=true" align=middle width=18.58454399999999pt height=22.465723500000017pt/> a stochastic process and <img src="/tex/eb5d7400c8598f6c858c56e2c7d0c78f.svg?invert_in_darkmode&sanitize=true" align=middle width=74.92828529999998pt height=24.65753399999998pt/> its cumulative distribution. <img src="/tex/a918cf04cd0ac7535e7626be634cfb9e.svg?invert_in_darkmode&sanitize=true" align=middle width=18.58454399999999pt height=22.465723500000017pt/> is stationary when; <img src="/tex/e867f5dbfb564fbba5b2eaa29ead6462.svg?invert_in_darkmode&sanitize=true" align=middle width=74.0013417pt height=22.831056599999986pt/> we have that:
<p align="center"><img src="/tex/a879c88e5004a1a6e5cad2a482124436.svg?invert_in_darkmode&sanitize=true" align=middle width=144.218382pt height=17.9087172pt/></p>
Autoregressive models are instead defined as:
<p align="center"><img src="/tex/adfa95a6485f353f5059ae1c2b57d9a0.svg?invert_in_darkmode&sanitize=true" align=middle width=177.35020709999998pt height=16.4447778pt/></p>
In this models, we try to forecast future values using a linear combination of past values.
A different approach is taken by moving average processes since they do not use past values but instead a regression of the forecast errors.
Moving average models are defined as:
<p align="center"><img src="/tex/8ac04b285555220b26a8d4f75c9e4fd9.svg?invert_in_darkmode&sanitize=true" align=middle width=165.2118567pt height=17.031940199999998pt/></p>
The concatenation of the three gives us the ARIMA process obtained as:
<p align="center"><img src="/tex/0ecf28c5feb1e8c06042abec57556069.svg?invert_in_darkmode&sanitize=true" align=middle width=478.40431154999993pt height=45.56341019999999pt/></p>

The ARIMA process is better suited to capture the linearities of a stochastic process, but what about its nonlinearities? How can we capture them in order to get a better result in our prediction?
An attempt to overcome this problem could be the mixture of some other methods that are built to track such patterns. This is the reason why we chose the hybrid model ARIMA/ANN to do this job.
The mixed-use of ARIMA and neural networks was firstly made by P. Zhang.

In theoretical terms we assume a the time series to be constituted by two components one which is linear auto correlated <img src="/tex/bcd81920696e26093495d90eb4cd7b1b.svg?invert_in_darkmode&sanitize=true" align=middle width=16.153034699999992pt height=22.465723500000017pt/> and one <img src="/tex/531638c33e2138742873b26f670a7b4d.svg?invert_in_darkmode&sanitize=true" align=middle width=18.173560349999992pt height=22.465723500000017pt/> non linear. If we let the ARIMA model the linear component we'll end up with the residuals which contains the non linear component.
<p align="center"><img src="/tex/523f4f809349305aceafe07fecdb77f9.svg?invert_in_darkmode&sanitize=true" align=middle width=85.4508006pt height=18.7671198pt/></p>
Then we model our residuals with a ANN that will capture this nonlinearities using the normalized stock prices lagged one time. The reason behind the normalization is simple, we do not want the price size to affect our neural net wheigt but instead we want to look at the stock price behaviour. In our case:
<p align="center"><img src="/tex/b601326f4eb2206916bfc39a921b6e28.svg?invert_in_darkmode&sanitize=true" align=middle width=183.39041984999997pt height=20.2118565pt/></p>

## Plots

Profit/Loss plot
![PL](/Paper/images/PL_plot.png)

Confusion Matrix plot
![ConfuMat](/Paper/images/Confusion_matrix.png)

## Author
* **Marco Repetto**: [LinkedIn](https://www.linkedin.com/in/marco-repetto-256562b3/)
