*Forecast model for ND oil prices (nsa). 

*Download data from online into Stata. Recall from class the date does not work as downloaded. 
import delimited https://raw.githubusercontent.com/flynnecon/forecasting2025/refs/heads/main/data_files/ndoil.csv, clear

*Now we need to look fix the date portion. 

gen sdate = tm(1981m1) + _n-1
format sdate %tm
*This generates a Stata readable date that also makes sense for us as users. Next we get this put into Stata as time series data. 

tsset sdate

*We can now take a look at this as a time series graph with time series commands. 
tsline ndfpp

* This line will need a little editing. I think the format of the date in the CSV file is a problem so we will tinker with this in class. 
* If you try to run the commands below you will get nonsense answers because it reads the date as month day and the serial number will not be interpeted properly.
* gen yrdate = yofd(sdate)
* separate ndfpp, by(yrdate)
* gen month = month(sdate)
* twoway line ndfpp**** month if yrdate>=2016, legend(off) c(L) sy()

* Let's tinker with the dates then.
gen newdate1 = dofm(sdate)
format newdate1 %td
* Now we have a month-day-year representation and can pull off the extractions.
gen yrdate = yofd(newdate1)
separate ndfpp, by(yrdate)
gen month = month(newdate1)
twoway line ndfpp**** month if yrdate > 2016, legend(off) c(L) sy()

* Let's now look at the subseasonal plot. We create a plot for each month, note the "if" command to isolate the specific month of interest.

twoway line ndfpp yrdate if month==1, saving(price_jan, replace) title("Jan")
twoway line ndfpp yrdate if month==2, saving(price_feb, replace) title("Feb")
twoway line ndfpp yrdate if month==3, saving(price_mar, replace) title("Mar")
twoway line ndfpp yrdate if month==4, saving(price_apr, replace) title("Apr")
twoway line ndfpp yrdate if month==5, saving(price_may, replace) title("May")
twoway line ndfpp yrdate if month==6, saving(price_jun, replace) title("Jun")
twoway line ndfpp yrdate if month==7, saving(price_jul, replace) title("Jul")
twoway line ndfpp yrdate if month==8, saving(price_aug, replace) title("Aug")
twoway line ndfpp yrdate if month==9, saving(price_sep, replace) title("Sep")
twoway line ndfpp yrdate if month==10, saving(price_oct, replace) title("Oct")
twoway line ndfpp yrdate if month==11, saving(price_nov, replace) title("Nov")
twoway line ndfpp yrdate if month==12, saving(price_dec, replace) title("Dec")

* After we do that we want to combine these into one plot.
graph combine price_jan.gph price_feb.gph price_mar.gph price_apr.gph price_may.gph price_jun.gph price_jul.gph price_aug.gph price_sep.gph price_oct.gph price_nov.gph price_dec.gph, saving(subseason1, replace)

* This was all the years so we need to make a bit of an alteration.
twoway line ndfpp yrdate if yrdate >=2016, by(month) saving(subseason2, replace)

