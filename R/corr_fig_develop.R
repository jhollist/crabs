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
      select(-habitat,-site_id) %>%
      corr.test(use="pairwise")
  
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

crab_corr_data <- read_csv(here("data/crab_corr_data.csv"))

for(i in unique(crab_cor_data$habitat)){
  calc_correlation(xdf, i)
}


bcb_corr <- crab_corr_data %>%
  spread(variable, value) %>%
  filter(habitat == "bcb") %>%
  select(-habitat,-site_id) %>%
  corr.test(use="pairwise")

bcb_corr_r <- data.frame(bcb_corr$r) %>%
  mutate(variables = row.names(.)) %>%
  select(variables,burrow_density,carcinus_cpue,sesarma_cpue,uca_cpue) %>%
  filter(variables != "burrow_density",
         variables != "carcinus_cpue",
         variables != "sesarma_cpue",
         variables != "uca_cpue") %>%
  mutate(habitat = "bcb")%>%
  gather(crab_param, pearson_cor,2:5) %>%
  select(habitat,crab_params, env_params = variables, pearson_cor)

bcb_corr_n <- data.frame(bcb_corr$n) %>%
  mutate(variables = row.names(.)) %>%
  select(variables,burrow_density,carcinus_cpue,sesarma_cpue,uca_cpue)
bcb_corr_p <- data.frame(bcb_corr$p) %>%
  mutate(variables = row.names(.)) %>%
  select(variables,burrow_density,carcinus_cpue,sesarma_cpue,uca_cpue)
  
  
 

  


