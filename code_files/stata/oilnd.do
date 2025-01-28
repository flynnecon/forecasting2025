*Forecast model for ND oil prices (nsa). 

*Download data from online into Stata. Recall from class the date does not work as downloaded. 
import delimited https://raw.githubusercontent.com/flynnecon/forecasting2025/refs/heads/main/oildata.csv, clear

*Now we need to look fix the date portion. 

gen sdate = tm(1981m1) + _n-1
format sdate %tm
*This generates a Stata readable date that also makes sense for us as users. Next we get this put into Stata as time series data. 

tsset sdata

*We can now take a look at this as a time series graph with time series commands. 
tsline ndfpp


