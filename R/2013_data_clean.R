library(dplyr)
library(stringr)
library(lubridate)
library(xts)
library(tidyr)
library(purrr)

dat_dirs <- c("/Volumes/GIS/LRPC/2013/06032013/raw", "/Volumes/GIS/LRPC/2013/06072013/raw",
  "/Volumes/GIS/LRPC/2013/06252013/raw", "/Volumes/GIS/LRPC/2013/07012013/raw",
  "/Volumes/GIS/LRPC/2013/07082013/raw", "/Volumes/GIS/LRPC/2013/07152013/raw",
  "/Volumes/GIS/LRPC/2013/07222013/raw", "/Volumes/GIS/LRPC/2013/07222013b/raw",
  "/Volumes/GIS/LRPC/2013/07292013/raw", "/Volumes/GIS/LRPC/2013/08052013/raw",
  "/Volumes/GIS/LRPC/2013/08122013/raw", "/Volumes/GIS/LRPC/2013/08192013/raw",
  "/Volumes/GIS/LRPC/2013/08262013/raw", "/Volumes/GIS/LRPC/2013/11182013/raw")

all <- read.csv("/Volumes/GIS/LRPC/All_LRPCcounts.txt", header = T)
all$CNTRNUM <- as.character(all$CNTRNUM)
all <- all %>% select(CNTRNUM, Town, Location, GDS_NAME, STATION, COUNTER, TYPE, COMBNUMS, Group, TYPE_1)

# Use custom function to read in a list of director names and clean counter data
counters <- read_counters(dat_dirs)

counters_13_join <- left_join(counters, all, by = c("counter" = "CNTRNUM")) %>% 
  distinct(counter, date_time, total, .keep_all = T)
#write.csv(counters_13_join, "data/counters_13_temp.csv")

day_count_13 <- counters_13_join %>% group_by(counter, date, Location) %>% 
  summarise(count = sum(total),
            count_low = min(total),
            count_hi = max(total),
            low_hr = time[which.min(total)],
            hi_hr = time[which.max(total)]) %>% 
  mutate(wday = lubridate::wday(date, label = TRUE))

write.csv(day_count_13, "data/day_count_13_temp.csv")

day_count %>% group_by(counter) %>%
    summarise(counts = mean(count)) %>% 
    arrange(-counts)


# There is one counter with 1 digit shorter identifier. Checking for errors
library(data.table)
day_count %>% filter(counter %like% "6217")

# Creating a list object for each counter
count_nest <- day_count %>% nest(counter)
