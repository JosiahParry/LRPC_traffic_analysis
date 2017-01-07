# Lists all directories with a specific ending extension
# dir: the path the to directory you want to list files to
# extension: string of path extension
# case_sensitive: will the desired extension search be case sensitive

list_dat_dirs <- function(dir, extension = "RAW", case_sensitive = FALSE) {
  case_sensitive <- ifelse(case_sensitive == TRUE, FALSE, TRUE)
  list.dirs(dir)[str_detect(list.dirs(dir),
                                        fixed(extension, ignore_case = case_sensitive))]
}
