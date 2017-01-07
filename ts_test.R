library(dplyr)
library(xts)
library(purrr)
library(tidyr)
#install.packages("forecast")
library(forecast)

counts_split <- counters %>% 
#selecting only the counters, date and count as I want to build a time series
                  select(counter, date_time, total) %>% 
# splitting the data by the counter so each counter has its own data frame
                  split(.$counter) %>% 
# Removing counter name so each data frame can become a univariate time series
# The name of the data frame is the counter identification
                  lapply(FUN = select, c(date_time, total))


xts(counts_split[[1]]$total,
    order.by = counts_split[[1]]$date_time)

counts_xts <- counts_split %>%
  map(~ xts(.x$total, order.by = .x$date_time))

plot(counts_xts[[1]])
a <- ets(counts_xts[[1]])

# Create a test time series
test <- counts_xts[[2]]
# When does the time series begin?
start(test)
# When does the series end?
end(test)
# What is the frequency of the series?
frequency(test)

# Came out to 0.00027777.. it should be 24 as there are 24 hours in a day
# Going to convert to ts class so it can have a frequency of 24
# In order to maintain a 24 frequency it needs to be in ts or zoo. I'm going to shoot for ts
            # Not needed anymore {#install.packages("anytime") to convert epoch seconds to time 
  #(using EDT) as that is what data was collected in
  #library(anytime)
  #index(test) <- anytime(index(test))
  }
test <- ts(test, frequency = 24)

# Test frequency again
frequency(test)

# Check to see how many cycles there are
cycle(test)
# Summary
summary(test)

# Plotting it to visualise 
plot(test)
abline(reg = lm(test ~ time(test)))

# Visualize the aggregate trend (only goes from time 1- 6)?? Don't understand this chart
plot(aggregate(test, FUN = mean))

# View a boxplot for each hour
boxplot(test ~ cycle(test), xlim= c(1, 24))
grid(nx=24, ny= NULL) # create a grid in the back to help identify hours better
#11 PM has the most variance of any other hour
# Very in active from early lunch hours to early office departure (11-4)
plot(pacf(test))
plot(acf(test))


#An ARIMA model is usually written as ARIMA(p,d,q), where p is the AR (Autocorrelation) order, 
#d is the degree of differencing, and q is the MA (Moving Average)
#An addition to this approach is can be, if both ACF and PACF decreases gradually, 
#it indicates that we need to make the time series stationary and introduce a value to “d”.
arima(test, c(1,1,0))


