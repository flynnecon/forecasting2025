*Forecast model for ND oil prices (nsa). 

*Download data from online into Stata. Recall from class the date does not work as downloaded. 
import delimited https://raw.githubusercontent.com/flynnecon/forecasting2025/refs/heads/main/oildata.csv, clear

*Now we need to look fix the date portion. 

gen sdate = tm() + _n-1
format sdate %tm


