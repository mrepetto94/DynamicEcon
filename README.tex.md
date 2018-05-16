# DynamicEcon
A project on Dynamic Econometrics.
The paper proposes a hybrid combination of ARIMA process and ANN in order to perform equity trading. Transaction costs were not taken into account.

## In brief
ARIMA processes are a class of univariate time series models, this kind of models attempt to predict financial variables using only information contained in their own past values and possibly current and past values of an error term. ARIMA process differs from the exponential smoothing since ARIMA focuses on the autocorrelation of the time series instead of trend and seasonality. Such model firstly proposed by Box-Jenkins combines three factors, namely: differencing, autoregressive model and moving average model.

Where differencing is intend as the process of transformation of the time series such that we end up with a stationary time series which has as main property no time dependency, in other terms given $X_t$ a stochastic process and $F_X(x_{t_k+\theta})$ its cumulative distribution. $X_t$ is stationary when; $\forall k,\theta and t_k$ we have that:
$$ F_x(x_{t_{k+\theta}}) = F_x(x_{t_k}) $$
Autoregressive models are instead defined as:
$$ c+\phi_1L+...+\phi_pL^p+\epsilon_t $$
In this models, we try to forecast future values using a linear combination of past values.
A different approach is taken by moving average processes since they do not use past values but instead a regression of the forecast errors.
Moving average models are defined as:
$$ c + (\theta_1 L + ... + \theta_q L^q)\epsilon_t $$
The concatenation of the three gives us the ARIMA process obtained as:
$$
 \underbrace{1-\phi_1L-...-\phi_pL^p}_{AR(p)} + \underbrace{(1-L)^d y_t}_{Differencing(d)} + \underbrace{c + (1 + \theta_1 L + ... + \theta_q L^q)\epsilon_t}_{MA(q)}
$$

## Author
* **Marco Repetto**: [LinkedIn](https://www.linkedin.com/in/marco-repetto-256562b3/)
