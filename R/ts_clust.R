library(tidyverse)
library(lubridate)
# Read in the factors for the 2013/2014 data
# Creating two tibbles from them and adding the year for reference
factors_13<- readRDS("data/factors_13_14.rds") %>%
  mutate(year = 2013)

factors_14 <- readRDS("data/factors_13_14.rds") %>%
  mutate(year = 2014)

# Need to reformat 2 variable names to fit 2013 & 2014
# Adding year to be used as the reference for the future join of all the counts
factors_15 <- readRDS("data/factors_15.rds") %>%
  mutate(year = 2015, GRP = GROUP, counter = COUNTER) %>%
  select(-GROUP, -COUNTER)

# Creating one tibble for all three years
factors_all <- bind_rows(factors_13, factors_14, factors_15)

# Remove other tibbles that wont be used & clean
rm(factors_13, factors_14, factors_15)
gc()

DOT_counts <- readRDS("data/DOT_counts.RDS") %>%
  mutate(year = year(date)) %>%
  arrange(date, time) %>%
  full_join(factors_all, by = c("year", "counter"))

