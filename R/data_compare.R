# Used this to try and track differences between correlation data xls, anova xls
# master xls, and reported correlations and anovas
# Master xls and anova xls get really close except for carcinus which has 
# minor differences.  Rounds looked a bit funny in anova xls.  correlation xls
# got exact anova match on bd and uca, but diff on carcinus and sesarma due to
# missing data for sesarma on mp and iva and carcinus on iva.  
# will use master to build data and re-run anova and correlation.  correlations 
# will be different b/c inclusion of sesarma mp and iva and carcinus iva.


library(tidyverse)
library(here)
library(readxl)

# Read in correlation data
corr_data <- crab_data %>%
  filter(variable == "burrow_density" |
           variable == "uca_cpue" |
           variable == "sesarma_cpue" |
           variable == "carcinus_cpue") %>%
  spread(variable, value) %>%
  select(-site_id) 

# Read in anova data
anova_data <- read_excel(here("data/crab data for beth anovas.xlsx")) %>%
  select(marsh = Marsh, habitat = Habitat, burrow_density = `Mean burrows`,
         uca_cpue = `Mean UCA CPUE`, sesarma_cpue = `Mean Sesarma CPUE`,
         carcinus_cpue = `Mean Carcinus CPUE`) %>%
  mutate(marsh = str_to_lower(marsh),
         habitat = case_when(habitat == "GCB" ~ "bcb",
                             habitat == "If" ~ "iva",
                             habitat == "MP" ~ "mp",
                             habitat == "VCB" ~ "vcb",
                             TRUE ~ habitat))

cd <- corr_data %>%
  group_by(marsh, habitat) %>%
  summarize(mean(carcinus_cpue)) %>%
  arrange(marsh, habitat)

ad <- anova_data %>%
  group_by(marsh, habitat) %>%
  summarize(mean(carcinus_cpue)) %>%
  arrange(marsh, habitat)

#nag, mp, sesarma 
#bis, iva, carcinus
