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

# Need to clean up variable names (elev and mean elev, spaalt and spalt, spapat and sppat, soil%, dispi and disspi, and height)
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
              

