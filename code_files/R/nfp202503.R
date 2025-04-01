---
title: "March 2025 Employment Forecast"
output: html_notebook
editor_options: 
  chunk_output_type: inline
---



#Setting up the various packages we might use to make our forecast. 
```{r}
library(tidyverse)
library(fpp3)
library(dplyr)
library(readxl)
library(tidyr)
library(tsibble)
library(tsibbledata)
library(lubridate)
library(feasts)
library(fable)
library(knitr)
library(ggstream)
library(ggpubr)
library(reshape2)
library(report)
library(readr)
urlfile="https://raw.githubusercontent.com/flynnecon/forecasting2025/refs/heads/main/data_files/nfp-20250401.csv"
```
#Getting the data read into R and then made into our time series analysis format. Note we do not need a training or test data division with the fact we are looking at a forecast 1 period ahead.
```{r Employment data work}
empdata202502 <- read_csv(url(urlfile))
empdata202502 <- empdata202402[c(2)]
empdata202502$date <- seq(as.Date("2001-01-01"), as.Date("2025-02-01"), by="1 month")
emp_tsbl202502 <- empdata202502 |> mutate(month=yearmonth(date)) |> as_tsibble(index=month)
```
#Just plotting employment here, the not seasoanlly adjusted biut. 
```{r plot of employment}
emp_tsbl202502 |> ggplot(aes(x=month,y=nfp)) + geom_line()
```
#Looking at the time series decomposition.
```{r decomposition work}
emp_tsbl202502 |>
  model(
    STL(nfp ~ trend(window = 7) +
                   season(window = "periodic"),
    robust = TRUE)) |>
  components() |>
  autoplot()
```

#Take the decomposition model and then a naive forecast will see you through to the outcome. 
```{r forecast by decomposition}
fit_dcmp <- emp_tsbl202502 |>
  model(stlf = decomposition_model(
    STL(nfp ~ trend(window = 7), robust = TRUE),
    NAIVE(season_adjust)
  ))
fit_dcmp |>
  forecast() |>
  autoplot(emp_tsbl202502)+
  labs(y = "Number of people",
       title = "US employment")
fit_out <-fit_dcmp |>
  forecast()
```
