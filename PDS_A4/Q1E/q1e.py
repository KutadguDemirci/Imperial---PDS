import pandas as pd

# Loading data, when I want to change some things in the data, in R the built-in tool is very powerful.
flights = pd.read_csv('flights.csv') 


# I don't like this way of column selection
flights['long_delayed_AA'] = (
    (flights['carrier'] == 'AA') &
    (flights['distance'] > 1000) & 
    (flights['arr_delay'] > 30)
)

# 3. Subsetting with .loc/.iloc is confusing, also not remembering .copy() can be very dangerous
flights_sub = flights.dropna(subset=['dep_time', 'arr_delay']).copy()
flights_sub['dep_hour'] = (flights_sub['dep_time'] // 100).astype(int)

# 4. Filtering
carrier_stats = (flights_sub.groupby('carrier')
                 .agg(avg_arr_delay = ('arr_delay', 'mean'),
                      total_flights = ('arr_delay', 'size'))
                 .round(2))

# 5. When to use .loc or direct indexing is confusing
flights.loc[flights['carrier'] == 'AA', 'arr_delay'] = 0  
flights[flights['carrier'] == 'AA']['arr_delay'] = 0      
