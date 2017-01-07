# dat_dirs: a vector of pathnames containing raw traffic counts in csv (comma separated) format
#      ^^^: first column must be the date, second column must be the time, all others are assume to be either #      ^^^: directions or total count and are aggregate
#n_skip: number of lines to be skipped, before csv begins; default is 0
#   ^^^: for example 2013 data had two lines to be skipped; n_skip = 2, 2014: n_skip = 3

read_counters <- function(dat_dirs, n_skip = 0) {
  
  all_files <- list()
  
  for (i in 1:length(dat_dirs)) {
    for (j in 1:length(list.files(dat_dirs[i]))) {
      all_files[length(list.files(dat_dirs[1:i])) - (length(list.files(dat_dirs[i])) - j)] <- 
        list(read_csv(file.path(dat_dirs[i],list.files(dat_dirs[i])[j]), 
                      skip = n_skip, col_names = TRUE,
                      col_types = cols(
                        Date = col_date("%m / %d / %Y")
                      )) %>% 
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
    df$date_time <- ymd_hms(paste(df$Date, df$Time))
    df <- dplyr::select(df, counter, Date, Time, date_time, total)
    `colnames<-`(df, tolower(colnames(df)))
    
  }
  do.call("rbind", lapply(all_files, counter_clean))
}
