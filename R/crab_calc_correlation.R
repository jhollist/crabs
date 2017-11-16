library(tidyverse)
library(here)
library(ggplot2)
library(psych)
source(here("R/functions.R"))

crab_data <- read_csv(here("data/crab_data.csv"))

crab_correlations <- data.frame()
for(i in unique(crab_data$habitat)){
  crab_correlations <- rbind(calc_correlation(crab_data, i),crab_correlations)
}

write_csv(crab_correlations, here("results/crab_correlations.csv"))
  
  
 

  


