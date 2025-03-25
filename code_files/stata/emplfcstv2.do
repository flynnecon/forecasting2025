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


  
*Now we want to create a forecast where we can perform evaluations over our time intervals. 
drop if _n > scalar(end)
gen employnd_new = .
replace employnd_new = employnd if date2 <= tm(2019m12)
summarize employnd_new
scalar newend = r(N)

*This will end up being the subset to our data if we want to use it that way. This is one way to set up your starting point. But there are others. 

*However there are advantages to the way we got this with the single variable in terms of just easy coding. 
egen newfcstmean = mean(employnd_new)
replace newfcstmean = employnd if date2 <= tm(2019m12)
tsline newfcstmean, saving(newfcstmean, replace)
*And there is our average. Yay us!!!


gen newfcstnaive = employnd_new
replace newfcstnaive = employnd_new[scalar(newend)] if newfcstnaive == .
tsline newfcstnaive, saving(newfcstnaive, replace)

*Seasonally naive forecast
gen newfcstseasnaive = employnd_new
replace newfcstseasnaive = newfcstseasnaive[_n-12] if _n > scalar(newend)
tsline newfcstseasnaive

*Drift forecast
gen newfcstdrift = employnd_new
replace newfcstdrift = newfcstdrift[_n-1] + ((employnd_new[scalar(newend)] - employnd_new[1])/(obs[scalar(newend)]-obs[1])) if _n > scalar(newend)
tsline newfcstdrift, saving(newfcstdrift, replace)

*With forecasts in place we can generate the forecast error which will be actual - predicted value. 
gen fcerr_mean = .
gen fcerr_naive = .
gen fcerr_snaive = .
gen fcerr_drift = .

*Calcualting the forecast errors
replace fcerr_mean = employnd - newfcstmean if _n > scalar(newend)
replace fcerr_naive = employnd - newfcstnaive if _n > scalar(newend)
replace fcerr_snaive = employnd - newfcstseasnaive if _n > scalar(newend)
replace fcerr_drift = employnd - newfcstdrift if _n > scalar(newend)

*Calculating the absolute errors
gen absfcerr_mean = abs(fcerr_mean)
gen absfcerr_naive = abs(fcerr_naive)
gen absfcerr_snaive = abs(fcerr_snaive)
gen absfcerr_drift = abs(fcerr_drift)

*Calculating the squared errors
gen sqfcerr_mean = fcerr_mean^2
gen sqfcerr_naive = fcerr_naive^2
gen sqfcerr_snaive = fcerr_snaive^2
gen sqfcerr_drift = fcerr_drift^2

*Calcuating the abosulte percentage error
gen apefcerr_mean = absfcerr_mean/employnd
gen apefcerr_naive = absfcerr_naive/employnd
gen apefcerr_snaive = absfcerr_snaive/employnd
gen apefcerr_drift = absfcerr_drift/employnd
