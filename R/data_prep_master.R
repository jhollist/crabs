library(tidyverse)

##################################
## Raw Data from master spreadsheet
##################################
crab_data <- readxl::read_excel(here("data/raw/Master file with all final data.xls"), skip = 1) %>%
  select(marsh = Marsh, habitat = Type, site_id = `Plot #`,  
         mean_burrows = `mean burrows`, burrow_density = `mean burrows m2`,
         uca_cpue = `Uca mean`, cover_spaalt = SPALT, bare = BARE, 
         height_spaalt = `Sa height`, elevation = `mean elevation`,      
         bulk_density = `soil bulk density`, perc_moisture = `soil % moisture`,
         perc_organic = `soil % organic`, shear_strength = `shear 10`, 
         cover_spapat = SPPAT, cover_disspi = DISPI, height_spapat = `Sp height`,
         height_disspi = `Ds height`, cover_junger = JUGER, cover_ivafru = IVFRU,
         height_junger = `Jg height`, sesarma_cpue = `SES mean`, 
         carcinus_cpue = `Cm mean`) %>%
  mutate(marsh = str_to_lower(marsh),
         habitat = case_when(habitat == "GCB" ~ "bcb",
                             habitat == "If" ~ "iva",
                             habitat == "MP" ~ "mp",
                             habitat == "VCB" ~ "vcb",
                             TRUE ~ habitat)) %>%
  gather(variable, value, mean_burrows:carcinus_cpue) %>%
  unique() %>%
  na.omit() 

write_csv(crab_data,here("data/crab_data.csv"))




