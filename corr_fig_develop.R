library(tidyverse)
library(here)
library(ggplot2)

crab_corr_data <- read_csv(here("data/crab_corr_data.csv"))

burrow_corr <- crab_corr_data %>%
  spread(variable, value)


