# Packages
library(dplyr)
library(tidyr)
library(here)
library(readxl)
library(readr)
library(stringr)

ssht <- here::here("data/jho_correlation_data.xlsx")
all_sheets <- lapply(excel_sheets(ssht), read_excel, path = ssht)
names(all_sheets)<-excel_sheets(ssht)

## Burrows MP sorted - using other MP variables to resort to same order
new_order <- match(all_sheets$`Carcinus MP`$elevation, all_sheets$`Burrows MP`$`mean elevation`)
all_sheets$`Burrows MP`<-all_sheets$`Burrows MP`[new_order,]

## Burrows MP didn't have shear 10 - Should be same as other MP
all_sheets$`Burrows MP`$`Shear 10` <- all_sheets$`Carcinus MP`$`shear 10`

crab_cor_data <- data.frame()
for(i in 1:length(all_sheets)){
  xdf <- all_sheets[[i]] %>%
    mutate(habitat = stringr::str_split(names(all_sheets)[i]," ")[[1]][2],
           site_id = row.names(.))
  if(names(xdf)[1] == "CPUE"){
    names(xdf)[1] <- paste(stringr::str_split(names(all_sheets)[i]," ")[[1]][1],
                          "cpue")
  } else {
    names(xdf)[1] <- "burrow density"
  }
  crab_cor_data <- xdf %>%
    gather(variable, value, c(-habitat, -site_id)) %>%
    rbind(.,crab_cor_data)
}

# Need to clean up variable names
# 1.) elevation and mean_elevation -> elevation
# 2.) dispi and disspi -> cover_disspi
# 3.) spaalt and spalt -> cover_spaalt
# 4.) spapat and sppat -> cover_spapat
# 5.) shear and shear_10 -> shear_strength
# 6.) ds_height and height_ds -> height_disspi
# 7.) height_patens and sp_height -> height_spapat
# 8.) sa_height and height_alt -> height_spaalt
# 9.) moisture and soil_% moisture -> perc_moisture
# 10.) organic and soil_% organic -> perc_organic
# 11.) bulk and soil_bulk density -> bulk_density
# 12.) ivafru -> cover_ivafru
# 13.) junger -> cover_junger

crab_cor_data <- crab_cor_data %>%
  mutate(habitat = str_to_lower(habitat),
         variable = str_to_lower(variable)) %>%
  mutate(variable = case_when(grepl(" - ", variable) ~
                                str_replace(variable, " - ", "_"),
                              grepl(" ", variable) ~ 
                                str_replace(variable, " ", "_"),
                              TRUE ~ variable)) %>%
  unique()

write_csv(crab_cor_data,here("data/crab_corr_data.csv"))
              

