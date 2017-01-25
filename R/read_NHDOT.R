read_NHDOT <- function(directory, extension = "RAW", n_skip = 6){
  library(gdata)
  source("R/list_dat_dirs.R")
  dat_dirs <- list_dat_dirs(directory, extension = extension)
  all_files <- list()
  for (i in 1:length(dat_dirs)) {
    for (j in 1:length(list.files(dat_dirs[i]))) {
      all_files[length(list.files(dat_dirs[1:i])) - (length(list.files(dat_dirs[i])) - j)] <- 
        list(read.xls(file.path(dat_dirs[i],list.files(dat_dirs[i])[j]), skip = n_skip) %>%
               mutate(date = mdy(paste(month(as.numeric(str_extract(list.files(dat_dirs[i])[j],
                                                                    "[:digit:]+"))), 
                                       X,
                                       str_extract_all(list.files(dat_dirs[i])[j], 
                                                       "[:digit:]+")[[1]][2])),
                      counter = str_extract(dat_dirs[i], "[:digit:]+")) %>%
               select(-X, - TOTAL))
    }
    temp <- do.call("bind_rows", all_files) %>% 
      gather(key = time, value = count, -counter, -date)
  } 
  temp$time <- str_replace(temp$time, "X", "")
  temp$time <- str_replace_all(temp$time, "[.]", ":")
  temp$time <- str_trunc(temp$time, 8, side = "right", ellipsis = "")
  temp
}