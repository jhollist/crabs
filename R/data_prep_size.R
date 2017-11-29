source("R/functions.R")

#####################              
## Temporal Data Prep
#####################
burrow_size_data <- read_excel(here("data/raw/Burrow data for histograms.xls"), "for sigmaplot") %>%
  mutate(variable = "burrow_diameter", value = Overall * 0.1) %>% #converts to cm from mm
  select(-Overall)
  
crab_size_data <- read_excel(here("data/raw/species size histograms.xls"),range = "F1:H325") %>%
  select(sesarma_carapace = `Sesarma (W)`, carcinus_carapace = `Carcinus (W)`, uca_carapace = `Uca (W)`) %>%
  gather(variable, value, 1:3)

size_data <- rbind(burrow_size_data, crab_size_data)

write_csv(size_data, here("data/size_data.csv"))
