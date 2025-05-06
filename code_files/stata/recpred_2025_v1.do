* Recession Prediction Model
* Spring 2025
* Economics 411


import delimited "https://raw.githubusercontent.com/flynnecon/forecasting2025/refs/heads/main/data_files/recmodel.csv", clear

* This is a basic model for predicting recession. I have a few variables but not necessarily an inclusive list.

gen sdate = tm(1960m1) + _n-1
format sdate %tm
tsset sdate
gen spread = gs10 - gs3m

