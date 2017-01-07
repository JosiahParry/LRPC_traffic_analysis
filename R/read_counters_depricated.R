#require(dplyr)
#require(stringr)
#require(lubridate)

read_counters <- function(dat_dirs) {
  
  all_files <- list()

  for (i in 1:length(dat_dirs)) {
    for (j in 1:length(list.files(dat_dirs[i]))) {
      all_files[length(list.files(dat_dirs[1:i])) - (length(list.files(dat_dirs[i])) - j)] <- 
        list(read.table(file.path(dat_dirs[i],list.files(dat_dirs[i])[j]), 
                        skip = 2, header = TRUE, sep = ",", ) %>% 
               mutate(counter = list.files(dat_dirs[i])[j] %>%
                        str_replace_all(".txt", "")) %>% 
               select(Date, Time, counter, everything()))
    }
  }

  counter_clean <- function(df, total = "total") {
    df <- data.frame(df)
    if (dim(df)[2] > 4) {
      df[, total] <-  apply(df[, -c(1:3)], 1, sum)
    } else {
      df[, total] <- df[, 4]
    }
    df$Date <- as.Date(df$Date, "%m / %d / %Y")
    df$date_time <- ymd_hms(paste(df$Date, df$Time))
    df <- dplyr::select(df, counter, Date, Time, date_time, total)
    `colnames<-`(df, tolower(colnames(df)))
   
  }
  
  
  do.call("rbind", lapply(all_files, counter_clean))
}
