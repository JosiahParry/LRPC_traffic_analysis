library(tidyverse)
library(lubridate)
library(stringr)
#devtools::install_github("guiastrennec/ggplus")
library(ggplus)
DOT_counts <- readRDS("data/DOT_counts.RDS")
DOT_counts <- DOT_counts %>%
  mutate(year = year(date),
         day = wday(date, label = TRUE),
         month = month(date, label = TRUE))

DOT_daily_avgs <- DOT_counts %>%
  group_by(counter, year , month, day, date) %>%
  summarise(daily_total = sum(count)) %>% 
  group_by(counter, year, month, day) %>%
  summarise(avg_day = mean(daily_total, na.rm = TRUE)) %>% 
  mutate(ymd = ymd(sprintf('%04d%02d%02d', year, month, day)))

DOT_wday_avg <- DOT_counts %>%
  filter(day %in% c("Mon", "Tues", "Wed", "Thurs", "Fri")) %>%
  group_by(counter, year, month, day, date) %>%
  summarise(daily_total = sum(count)) %>% 
  group_by(counter, year, month) %>%
  summarise(avg_wday = mean(daily_total, na.rm = TRUE)) 

# Now I must split each data frame based on the group and year
# Then will calculate the averages for the group
# Read in factors 
fctr_13_14 <- readRDS("data/factors_13_14.rds")
fctr_15 <- readRDS("data/factors_15.rds")

DOT_13_daily <- filter(DOT_daily_avgs, year == "2013") %>%
  inner_join(fctr_13_14, by = "counter")

DOT_14_daily <- filter(DOT_daily_avgs, year == "2014") %>%
  inner_join(fctr_13_14, by = "counter")

DOT_15_daily <- filter(DOT_daily_avgs, year == "2015") %>%
  inner_join(fctr_15, by = c("counter" = "COUNTER"))

DOT_13_wday <- filter(DOT_wday_avg, year == "2013") %>%
  inner_join(fctr_13_14, by = "counter")

DOT_14_wday <- filter(DOT_wday_avg, year == "2014") %>%
  inner_join(fctr_13_14, by = "counter")

DOT_15_wday <- filter(DOT_wday_avg, year == "2015") %>%
  inner_join(fctr_15, by = c("counter" = "COUNTER"))


## Calculate Sunday Factors
DOT_13_sun <- DOT_13_daily %>% filter(day == "Sun") %>%
  group_by(GRP, month) %>%
  summarise(avg_sun = mean(avg_day)) %>%
  mutate(year_sun_avg = mean(avg_sun),
         sun_fctr = avg_sun / year_sun_avg)%>%
  arrange(GRP)

DOT_14_sun <- DOT_14_daily %>% filter(day == "Sun") %>%
  group_by(GRP, month) %>%
  summarise(avg_sun = mean(avg_day)) %>%
  mutate(year_sun_avg = mean(avg_sun),
         sun_fctr = avg_sun / year_sun_avg)%>%
  arrange(GRP)

DOT_15_sun <- DOT_15_daily %>% filter(day == "Sun") %>%
  group_by(GROUP, month) %>%
  summarise(avg_sun = mean(avg_day)) %>%
  mutate(year_sun_avg = mean(avg_sun),
         sun_fctr = avg_sun / year_sun_avg)%>%
  arrange(GROUP)

## Calculate Saturday Factors 
DOT_13_sat <- DOT_13_daily %>% filter(day == "Sat") %>%
  group_by(GRP, month) %>%
  summarise(avg_sat = mean(avg_day)) %>%
  mutate(year_sat_avg = mean(avg_sat),
         sat_fctr = avg_sat / year_sat_avg)%>%
  arrange(GRP)

DOT_14_sat <- DOT_14_daily %>% filter(day == "Sat") %>%
  group_by(GRP, month) %>%
  summarise(avg_sat = mean(avg_day)) %>%
  mutate(year_sat_avg = mean(avg_sat),
         sat_fctr = avg_sat / year_sat_avg)%>%
  arrange(GRP)

DOT_15_sat <- DOT_15_daily %>% filter(day == "Sat") %>%
  group_by(GROUP, month) %>%
  summarise(avg_sat = mean(avg_day)) %>%
  mutate(year_sat_avg = mean(avg_sat),
         sat_fctr = avg_sat / year_sat_avg)%>%
  arrange(GROUP)

## Calculate weekday factors
DOT_13_wday_fctr <- DOT_13_wday %>% 
  group_by(GRP, month) %>%
  summarise(avg_wday = mean(avg_wday)) %>%
  mutate(year_wday_avg = mean(avg_wday),
         wday_fctr = avg_wday / year_wday_avg)

DOT_14_wday_fctr <- DOT_14_wday %>% 
  group_by(GRP, month) %>%
  summarise(avg_wday = mean(avg_wday)) %>%
  mutate(year_wday_avg = mean(avg_wday),
         wday_fctr = avg_wday / year_wday_avg)

DOT_15_wday_fctr <- DOT_15_wday %>% 
  group_by(GROUP, month) %>%
  summarise(avg_wday = mean(avg_wday)) %>%
  mutate(year_wday_avg = mean(avg_wday),
         wday_fctr = avg_wday / year_wday_avg)

## Calculate daily factors
DOT_13_day_fctr <- DOT_13_daily %>%
  group_by(GRP, month) %>%
  summarise(avg_day = mean(avg_day)) %>%
  mutate(year_day_avg = mean(avg_day),
         day_fctr = avg_day / year_day_avg)

DOT_14_day_fctr <- DOT_14_daily %>%
  group_by(GRP, month) %>%
  summarise(avg_day = mean(avg_day)) %>%
  mutate(year_day_avg = mean(avg_day),
         day_fctr = avg_day / year_day_avg)

DOT_15_day_fctr <- DOT_15_daily %>%
  group_by(GROUP, month) %>%
  summarise(avg_day = mean(avg_day)) %>%
  mutate(year_day_avg = mean(avg_day),
         day_fctr = avg_day / year_day_avg)



# Join the factors
DOT_13_fctr <- bind_cols(DOT_13_day_fctr, DOT_13_sat, DOT_13_sun, DOT_13_wday_fctr)[!duplicated(names(
  bind_cols(DOT_13_day_fctr, DOT_13_sat, DOT_13_sun, DOT_13_wday_fctr)))]

DOT_14_fctr <- bind_cols(DOT_14_day_fctr, DOT_14_sat, DOT_14_sun, DOT_14_wday_fctr)[!duplicated(names(
  bind_cols(DOT_14_day_fctr, DOT_14_sat, DOT_14_sun, DOT_14_wday_fctr)))]

DOT_15_fctr <- bind_cols(DOT_15_day_fctr, DOT_15_sat, DOT_15_sun, DOT_15_wday_fctr)[!duplicated(names(
  bind_cols(DOT_15_day_fctr, DOT_15_sat, DOT_15_sun, DOT_15_wday_fctr)))]

## Cleaning the working environment
rm(list = ls()[!ls() %in% c("DOT_13_fctr","DOT_14_fctr", "DOT_15_fctr")])
gc()



#---

#PLOTS
#gg <- ggplot(DOT_daily_avgs, 
#       aes(x = ymd, y = avg_day, color = counter )) +
#  geom_line() +
#  geom_smooth() +
#  geom_point()

#gg_faceted <- facet_multiple(gg, facets = c("counter", "year"), ncol = 3, nrow = 3, scales = "free")
