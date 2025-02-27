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

*Model 1 for forecast
ucm employnd, model(rtrend) seasonal(12)
estimates store model1
predict fc1
predict fc2, dynamic(tm(2024m1))
predict trendest1, trend
predict seasonest1, season

*Model 2 for forecast
*This model fails to converge, at least when I run it. I let it go for nearly 300 iterations with little change in convergence criteria. This is a sign of a model that might not be running appropriately. 
ucm employnd, model(strend) seasonal(12)
estimates store model2
predict fc3
predict fc4, dynamic(tm(2024m1))



