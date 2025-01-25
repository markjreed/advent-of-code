#!/usr/bin/env rscript
library(scriptName)
args <- commandArgs(TRUE)
if (length(args) != 1) {
     write(paste("Usage: ", current_filename(), " input-number"), stderr())
     .Internal(.invokeRestart(list(NULL, NULL), NULL))
}

target <- as.numeric(args[1]) 
count <- trunc(target / 10)
houses1 <- rep(10, count)
houses2 <- 11 * seq(1, count)
for (elf in 2:count) {
    for (num in seq(elf,count,elf)) {
        houses1[num] <- houses1[num] + 10 * elf
    }
    max <- floor(count / elf)
    if (max > 50) { max <- 50 }
    for (num in 2:max) {
        
        houses2[num * elf] <- houses2[num * elf] + 11 * elf
    }
}
part1 <- 0
part2 <- 0
for (i in 1:count) {
    if (houses1[i] >= target && part1 == 0) {
        part1 <- i
    }
    if (houses2[i] >= target && part2 == 0) {
        part2 <- i
        break
    }
}
print(part1)
print(part2)
