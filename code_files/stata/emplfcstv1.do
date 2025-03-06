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

*Working on our benchmark forecasts.

*Start to build our baseline methods
gen obs = _n
qui summarize(obs)
qui scalar end = r(max)
tsappend, add(36)

*Mean or average forecast approach, add in a count of the observations and then add 12 more observations. 
egen fcstmean = mean(employnd)
replace fcstmean = employnd if _n < scalar(end)
tsline fcstmean, saving(fcstmean, replace)
*And there is our average. Yay us!!!

*Naive forecast - last value
gen fcstnaive = employnd
replace fcstnaive = employnd[scalar(end)] if fcstnaive == .
tsline fcstnaive, saving(fcstnaive, replace)

*Seasonally naive forecast
gen fcstseasnaive = employnd
replace fcstseasnaive = employnd[_n-12] if fcstseasnaive == .
tsline fcstseasnaive, saving(fcstnaive, replace)

*Drift method
gen fcstdrift = employnd
replace fcstdrift = fcstdrift[_n-1] + ((employnd[scalar(end)] - employnd[1])/(obs[scalar(end)]-obs[1])) if fcstdrift == .
tsline fcstdrift, saving(fcstdrift, replace)
*Selection of the time frame can be very crucial in the performance of a drift forecast.


*Here is a devilish combination of my own concoction!!
gen fcstseas_drift = employnd
replace fcstseas_drift = fcstseas_drift[_n-12] + ((employnd[scalar(end)] - employnd[1])/(obs[scalar(end)]-obs[1])) if fcstseas_drift == .
tsline fcstseas_drift, saving(fcstseas_drift, replace)
