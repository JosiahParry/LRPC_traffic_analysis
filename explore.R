#To calculate a seasonal adjustment factor, or any adjustment factor, we need to first find the average across all points (i.e. all 4 quarters, all 24 hours, etc.). Then we take that average and divide each point by that value. For example I would f ind the average of all 4 fiscal quarters, then divide Q1 by the mean to find the Q1 adjustment factor for that input and that year. Then we must find the seasonal indeces.


counters_13 %>% group_by(counter,time) %>% 
  summarise(avg = mean(total),
            count_hi = max(total),
            count_low = min(total),
            sd = sd(total),
            se = sd(total)/sqrt(length(total)))

test <- counters_13 %>%
  select(counter, date, time, wday, date_time, total) %>%
  mutate(month = month(date, label = T))

saf_row_mean <- test %>% group_by(date) %>% 
  summarise(avg = mean(total))


saf_rm_spread <- saf_row_mean %>% spread(wday,avg)

test2 <- test %>%
  select(counter, date, time, wday,month, total) %>% 
  spread(wday, total)



counts_month <- test2 %>% group_by(counter, month) %>%
  summarise_at(vars(Sun, Mon, Tues, Wed, Thurs, Fri, Sat), funs(mean), na.rm = T)
