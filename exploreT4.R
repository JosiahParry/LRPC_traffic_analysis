library(ggplot2)

counters_13 <- read_csv("data/clean_counts/counters_13.csv")
counters_14 <- read_csv("data/clean_counts/counters_14.csv")

counters_13 <- counters_13 %>%
  mutate(wday = wday(date, label = T),
         month = month(date, label = T))

tier_4 <- counters_13 %>%
  filter(TIER == 4)

counters_13 %>%
  group_by(wday) %>%
  summarise(avg = mean(total),
            count_hi = max(total),
            count_low = min(total),
            sd = sd(total),
            se = sd(total)/sqrt(length(total)))

x <- tier_4 %>%
  group_by(counter, date) %>% 
  summarise(total = sum(total)) %>%
  mutate(wday = wday(date, label = TRUE))

x %>%
  ggplot(aes(date, total)) +
    geom_line() +
    scale_x_date() +
    facet_wrap(~counter, scales = "free")