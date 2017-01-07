counters_13 <- read.csv("Data/counters_13_temp.csv") %>% select(-X)

counters_13 <- counters_13 %>%
  mutate(wday = wday(date, label = T))

counters_13 %>%
  group_by(wday) %>%
  summarise(avg = mean(total),
            count_hi = max(total),
            count_low = min(total),
            sd = sd(total),
            se = sd(total)/sqrt(length(total)))