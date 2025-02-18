*Forecast model for employment (nsa). 

*Download data from online into Stata. Recall from class the date does not work as downloaded. 
import delimited https://raw.githubusercontent.com/flynnecon/forecasting2025/refs/heads/main/data_files/usndemploy.csv, clear

*Now we need to fix the data. This is long data and we want it wide.  
reshape wide employ, i(statdate) j(region) string


gen sdate = tm(2015m1) + _n-1
format sdate %tm
*This generates a Stata readable date that also makes sense for us as users. Next we get this put into Stata as time series data. 

tsset sdate

*We can now take a look at this as a time series graph with time series commands. 
tsline ndfpp
