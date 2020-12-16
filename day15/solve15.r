#!usr/bin/env Rscript
library("optparse")
option_list = list(
  make_option(c("-v", "--verbose"), action="store_true", type="logical", default=FALSE, help="Show turn by turn"),
  make_option(c("-t", "--turn"), type="integer", default=2020, help="Turn to stop on", metavar="number"))

opt_parser <- OptionParser(option_list = option_list)
opt <- parse_args(opt_parser, positional_arguments = TRUE)

starting_list <- strsplit(opt$args[[1]], ",", fixed=TRUE)[[1]]
last <- starting_list[[length(starting_list)]]
starting_list <- starting_list[-length(starting_list)]
turn <- length(starting_list) + 1

spoken <- new.env(hash=TRUE, parent=emptyenv())
for (i in seq_along(starting_list)) {
  if (opt$options$verbose) {
    cat(c("Turn ", i, ": ", starting_list[[i]], "\n"))
  }
  spoken[[starting_list[[i]]]] <- i
}

while (turn < opt$options$turn) {
  if (opt$options$verbose) {
    cat(c("Turn ", turn, ": ", last, "\n"))
  }
  say <- 0
  key <- toString(last)
  if (exists(key, spoken)) {
    say <- turn - spoken[[key]]
  }
  spoken[[key]] <- turn
  last <- say
  turn <- turn + 1
}

if (opt$options$verbose) {
  cat(c("Turn ", turn, ": "))
}
cat(c(last, "\n"))
