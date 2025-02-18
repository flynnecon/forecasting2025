*Forecast model for employment (nsa). 

*Download data from online into Stata. Recall from class the date does not work as downloaded. 
import delimited https://raw.githubusercontent.com/flynnecon/forecasting2025/refs/heads/main/data_files/usndemploy.csv, clear

*Now we need to fix the data. This is long data and we want it wide. (See class explanation of these data types). We will find that life is infinitely easier for us if we convert the time variable first. 
gen date2 = monthly(statdate, "MY")
format date2 %tm

*Now we can reshape the data into the wide date set more appropriate for our time series needs. 
reshape wide employ, i(date2) j(region) string

*And then we can tsset the data. 
tsset date2

* We can then generate the moving average value for the 5 period centered moving average. 

tssmooth ma ma_nd = employnd, window(2 1 2) replace

tsline employnd ma_nd
