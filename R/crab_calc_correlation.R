library(tidyverse)
library(here)
library(ggplot2)
library(psych)

calc_correlation <- function(xdf, hab){
  parse_it <- function(df){
    df %>%
      mutate(variables = row.names(.)) %>%
      select(variables,burrow_density,carcinus_cpue,sesarma_cpue,uca_cpue) %>%
      filter(variables != "burrow_density",
             variables != "carcinus_cpue",
             variables != "sesarma_cpue",
             variables != "uca_cpue") %>%
      mutate(habitat = hab)
  }
  
  corr_df <- xdf %>%
      spread(variable, value) %>%
      filter(habitat == hab) %>%
      select(-habitat,-site_id, -marsh) %>%
      corr.test(use="pairwise", adjust = "none")

  r <- data.frame(corr_df$r) %>%
    parse_it() %>%
    gather(crab_params, pearson_cor,2:5) %>%
    select(habitat,crab_params, env_params = variables, pearson_cor)
  n <- data.frame(corr_df$n) %>%
    parse_it() %>%
    gather(crab_params, n,2:5) %>%
    select(habitat,crab_params, env_params = variables, n)
  p <- data.frame(corr_df$p) %>%
    parse_it() %>%
    gather(crab_params, p,2:5) %>%
    select(habitat,crab_params, env_params = variables, p)

  left_join(r,n) %>%
    left_join(p)
}

crab_data <- read_csv(here("data/crab_data.csv"))

crab_correlations <- data.frame()
for(i in unique(crab_data$habitat)){
  crab_correlations <- rbind(calc_correlation(crab_data, i),crab_correlations)
}

write_csv(crab_correlations, here("results/crab_correlations.csv"))
  
  
 

  


