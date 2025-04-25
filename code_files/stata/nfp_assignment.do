* Time Series Models

* These are distinct from methods because a model actually is an effort to establish how the world evolves or operates. 


*Download data from online into Stata. Recall from class the date does not work as downloaded. 
import delimited https://raw.githubusercontent.com/flynnecon/forecasting2025/refs/heads/main/data_files/nfp-assignment.csv, clear

*Normal time series commands. 
gen sdate = tm(2001m1) + _n-1
format sdate %tm
tsset sdate

