source("R/functions.R")

#####################              
## Temporal Data Prep
#####################
temporal_data <- read_excel(here("data/raw/jho_temporal_data_summarized.xlsx"),2) %>%
  filter(variable != "burrow_density") #yank old data

temporal_bd_data_1998 <- read_excel(here("data/raw/Crab Burrow Counts Ten Sites 1998 2016.xlsx"),sheet=1,
                                         range = "A6:I16") %>%
  mutate(year = year(ymd(`date of observation`)),
         low_1 = `low marsh zone 1`/`quadrat size (m2)`,
         low_2 = `low marsh zone 2`/`quadrat size (m2)`,
         low_3 = `low marsh zone 3`/`quadrat size (m2)`,
         high_1 = `high marsh zone 1`/`quadrat size (m2)`,
         high_2 = `high marsh zone 2`/`quadrat size (m2)`,
         high_3 = `high marsh zone 3`/`quadrat size (m2)`,
         Site = tolower(Site)
         ) %>%
  select(year, site_id = Site, low_1, low_2, low_3, high_1, high_2, high_3) %>%
  gather(habitat, burrow_density, 3:8) %>%
  mutate(habitat = substr(habitat,1,nchar(habitat)-2),
         variable = "burrow_density") %>%
  select(year, site_id, habitat, variable, value = burrow_density)

temporal_bd_data_2016 <- read_excel(here("data/raw/Crab Burrow Counts Ten Sites 1998 2016.xlsx"),sheet=2,
                                    range = "A6:I16")%>%
  mutate(year = year(ymd(`date of observation`)),
         low_1 = `low marsh zone 1`/`quadrat size (m2)`,
         low_2 = `low marsh zone 2`/`quadrat size (m2)`,
         low_3 = `low marsh zone 3`/`quadrat size (m2)`,
         high_1 = `high marsh zone 1`/`quadrat size (m2)`,
         high_2 = `high marsh zone 2`/`quadrat size (m2)`,
         high_3 = `high marsh zone 3`/`quadrat size (m2)`,
         Site = tolower(Site)
  ) %>%
  select(year, site_id = Site, low_1, low_2, low_3, high_1, high_2, high_3) %>%
  gather(habitat, burrow_density, 3:8) %>%
  mutate(habitat = substr(habitat,1,nchar(habitat)-2),
         variable = "burrow_density") %>%
  select(year, site_id, habitat, variable, value = burrow_density)

temporal_data <- rbind(temporal_data, temporal_bd_data_1998, temporal_bd_data_2016)

write_csv(temporal_data, here("data/temporal_data.csv"))
