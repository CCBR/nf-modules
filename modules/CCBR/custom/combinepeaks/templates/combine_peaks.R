#!/usr/bin/env Rscript
library(dplyr)
library(purrr)
library(stringr)
library(readr)
library(tidyr)

main <- function() {
  write_lines(get_version(), "versions.yml")
  print("${peakcounts}")
  dat <- combine_peaks(unlist(str_split("${count_files}", ",")))
  write_tsv(dat, "${outfile}", col_names = FALSE)
}

get_version <- function() {
  return(paste0(R.version[["major"]], ".", R.version[["minor"]]))
}

combine_peaks <- function(count_files) {
  count_dat <- count_files %>%
    map(function(file) {
      dat <- read_tsv(file, col_names = FALSE)
      colnames(dat) <- c("peakID", "count")
      return(dat %>% mutate(file = file))
    }) %>%
    list_rbind() %>%
    group_by(peakID) %>%
    summarize(score = format(sum(count) / length(count_files), nsmall = 3)) %>%
    separate_wider_delim(peakID, ":", names = c("chrom", "coords"), cols_remove = FALSE) %>%
    separate_wider_delim(coords, "-", names = c("start", "end")) %>%
    mutate(
      start = as.numeric(start), end = as.numeric(end),
      strand = ".", signal = NA, pvalue = NA, qvalue = NA
    ) %>%
    arrange(chrom, start, end)
  return(count_dat)
}

main()
