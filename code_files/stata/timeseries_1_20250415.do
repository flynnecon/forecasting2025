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

* If we want a graph of the total post-covid data set just deleate the asterisk at the start of the next line.
* tsline nfp_postcovid if sdate >= tm(2020m4)

* Do we need all these tests? Maybe, maybe not. But what do they tell us overall?
* An alternative test is the KPSS test, which is more than a unit root test it is an overall stationarity test, with a different null hypothesis. 
*findit kpss

kpsstest nfp
kpsstest nfp_postcovid
kpsstest nfp_train
kpsstest nfp_test


*Differencing now
dfuller d.nfp_postcovid
kpsstest d.nfp_postcovid
dfuller d.nfp_train
kpsstest d.nfp_train
dfuller d2.nfp_train
kpsstest d2.nfp_train
* tsline nfp_train
* tsline nfp_train if sdate >= tm(2020m4)
* tsline d.nfp_train if sdate >= tm(2020m4)
* tsline d2.nfp_train
* tsline d2.nfp_train if sdate >= tm(2020m4)

arima nfp_train, arima(1 0 0)
estimates store hope
*Takes a long time to converge. Tests say to difference.
arima d.nfp_train, arima(1 0 0)
estimates store thoughts
predict pred_train1
arima nfp_train, arima(1 1 0)
predict pred_train2
estimates store prayers
arima nfp_train, arima(1 2 0)
estimates store deliverance

arimasoc d2.nfp_train


* tsline pred_train2 d.nfp_train if sdate >= tm(2020m4) & sdate <= tm(2023m3)

