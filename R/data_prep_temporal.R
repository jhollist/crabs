source("R/functions.R")

#####################              
## Temporal Data Prep
#####################
temporal_data <- read_excel(here("data/raw/jho_temporal_data_summarized.xlsx"),2)

write_csv(temporal_data, here("data/temporal_data.csv"))
