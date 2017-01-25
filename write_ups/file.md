This will go through the cleaning and joining process for **LRPC** 2013
and 2014 data.

First load master **LRPC** counter data (joined with **NH DOT**), and
the two function necessary for reading & cleaning raw count data:
`list_dat_dirs()` and `read_counters()`.

<!-- rnb-source-begin eyJkYXRhIjoiYGBgclxubHJwYyA8LSByZWFkUkRTKFwiLi4vZGF0YS9scnBjLlJEU1wiKVxuc291cmNlKFwiLi4vUi9yZWFkX2NvdW50ZXJzLlJcIilcbnNvdXJjZShcIi4uL1IvbGlzdF9kYXRfZGlycy5SXCIpXG5gYGAifQ== -->
    lrpc <- readRDS("../data/lrpc.RDS")
    source("../R/read_counters.R")
    source("../R/list_dat_dirs.R")

<!-- rnb-source-end -->
Next read in raw counts from 2013 and 2014.

<!-- rnb-source-begin eyJkYXRhIjoiYGBgclxuY291bnRzXzEzIDwtIGxpc3RfZGF0X2RpcnMoXCIvVm9sdW1lcy9HSVMvTFJQQy8yMDEzXCIpICU+JSByZWFkX2NvdW50ZXJzKG5fc2tpcCA9IDIpXG5jb3VudHNfMTQgPC0gbGlzdF9kYXRfZGlycyhcIi9Wb2x1bWVzL0dJUy9MUlBDLzIwMTRcIikgJT4lIHJlYWRfY291bnRlcnMobl9za2lwID0gMylcbmBgYCJ9 -->
    counts_13 <- list_dat_dirs("/Volumes/GIS/LRPC/2013") %>% read_counters(n_skip = 2)
    counts_14 <- list_dat_dirs("/Volumes/GIS/LRPC/2014") %>% read_counters(n_skip = 3)

<!-- rnb-source-end -->
Next these data need to be associated to their counter locations /
associated data from `lrpc`. The common field to be joined on is the
counter field. However in the `lrpc` file the field name is `COMBNUMS`
and both `counts_13` and `counts_14`, the field name is `counter`.

<!-- rnb-source-begin eyJkYXRhIjoiYGBgclxuZnVsbF9jb3VudHNfMTMgPC0gbGVmdF9qb2luKGNvdW50c18xMywgbHJwYywgYnkgPSBjKFwiY291bnRlclwiID0gXCJDT01CTlVNU1wiKSkgJT4lIFxuICBkaXN0aW5jdChjb3VudGVyLCBkYXRlX3RpbWUsIHRvdGFsLCAua2VlcF9hbGwgPSBUKVxuXG5mdWxsX2NvdW50c18xNCA8LSBsZWZ0X2pvaW4oY291bnRzXzE0LCBscnBjLCBieSA9IGMoXCJjb3VudGVyXCIgPSBcIkNPTUJOVU1TXCIpKSAlPiUgXG4gIGRpc3RpbmN0KGNvdW50ZXIsIGRhdGVfdGltZSwgdG90YWwsIC5rZWVwX2FsbCA9IFQpXG5gYGAifQ== -->
    full_counts_13 <- left_join(counts_13, lrpc, by = c("counter" = "COMBNUMS")) %>% 
      distinct(counter, date_time, total, .keep_all = T)

    full_counts_14 <- left_join(counts_14, lrpc, by = c("counter" = "COMBNUMS")) %>% 
      distinct(counter, date_time, total, .keep_all = T)

<!-- rnb-source-end -->
Now these should be saved to text files.

<!-- rnb-source-begin eyJkYXRhIjoiYGBgclxuI3dyaXRlX2NzdihmdWxsX2NvdW50c18xMywgXCJkYXRhL2NsZWFuX2NvdW50cy9jb3VudGVyc18xMy5jc3ZcIilcbiN3cml0ZV9jc3YoZnVsbF9jb3VudHNfMTQsIFwiZGF0YS9jbGVhbl9jb3VudHMvY291bnRlcnNfMTQuY3N2XCIpXG5gYGAifQ== -->
    #write_csv(full_counts_13, "data/clean_counts/counters_13.csv")
    #write_csv(full_counts_14, "data/clean_counts/counters_14.csv")

<!-- rnb-source-end -->
