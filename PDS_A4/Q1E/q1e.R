# This part looks bigger but its only because the I'm taking the nycflights13,
# the built-in tool for getting data inside RStudio is great
library(nycflights13)
hhmm_to_minutes <- function(time) {
  hour <- floor(time / 100)
  minute <- time %% 100
  total_minutes <- hour * 60 + minute
  return(total_minutes)
}
flights <- data.frame(nycflights13::flights)
airlines <- data.frame(nycflights13::airlines)
airports <- data.frame(nycflights13::airports)
flights_airlines <- merge(flights, airlines, by = "carrier")
flights_airlines_airports <- merge(flights_airlines, airports, by.x = "dest", by.y = "faa")


# Access columns is very clear, I dont like $ sign but at least its very clear how to do.
birthday_flights <- subset(flights, month==7 & day==15 & !is.na(arr_delay))
average_delay <- mean(birthday_flights$arr_delay)  # Clean column access

# Subsetting is very easy and straightforward
LAX_flights <- subset(flights_airlines_airports, name.y == "Los Angeles Intl")

# Conditional filtering or creating columns are straightforward as well since, accessing columns is straightforward
flights$sched_dur <- hhmm_to_minutes(flights$sched_arr_time) - 
                    hhmm_to_minutes(flights$sched_dep_time)

# Filter and aggregate again, straightforward
mean_delay <- aggregate(arr_delay ~ name.x, 
                       data = flights_airlines_airports, 
                       FUN = mean, 
                       na.rm = TRUE)

