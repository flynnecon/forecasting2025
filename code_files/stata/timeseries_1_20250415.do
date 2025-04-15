* Time Series Models

* These are distinct from methods because a model actually is an effort to establish how the world evolves or operates. 


*Download data from online into Stata. Recall from class the date does not work as downloaded. 
import delimited https://raw.githubusercontent.com/flynnecon/forecasting2025/refs/heads/main/data_files/nfp-20250414.csv, clear

*Normal time series commands. 
gen sdate = tm(2001m1) + _n-1
format sdate %tm
tsset sdate

* Create various data subsets
gen nfp_postcovid = nfp if sdate >= tm(2020m4)
gen nfp_train = nfp_postcovid if sdate <= tm(2023m3)
gen nfp_test = nfp_postcovid if sdate > tm(2023m3)


* Test for unit roots in the full and sub samples. Why test now and not in the exponential smoothing estimation?
dfuller nfp
dfuller nfp_postcovid
dfuller nfp_train
dfuller nfp_test

* Do we need all these tests? Maybe, maybe not. But what do they tell us overall?

arima nfp_train, arima(1 0 0)
*Takes a long time to converge. Tests say to difference.
arima d.nfp_train, arima(1 0 0)
predict pred_train1
arima nfp_train, arima(1 1 0)
predict pred_train2

tsline pred_train2 d.nfp_train if sdate >= tm(2020m4) & sdate <= tm(2023m3)

