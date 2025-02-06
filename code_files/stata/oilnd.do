*Forecast model for ND oil prices (nsa). 

*Download data from online into Stata. Recall from class the date does not work as downloaded. 
import delimited https://raw.githubusercontent.com/flynnecon/forecasting2025/refs/heads/main/data_files/ndoil.csv, clear

*Now we need to look fix the date portion. 

gen sdate = tm(1981m1) + _n-1
format sdate %tm
*This generates a Stata readable date that also makes sense for us as users. Next we get this put into Stata as time series data. 

tsset sdata

*We can now take a look at this as a time series graph with time series commands. 
tsline ndfpp

* This line will need a little editing. I think the format of the date in the CSV file is a problem so we will tinker with this in class. 
gen yrdate = yofd(Date)
separate ndfpp, by(yrdate)
gen month = month(Date)
twoway line retail**** month if yrdate>=2016, legend(off) c(L) sy()
