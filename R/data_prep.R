# Packages
library(dplyr)
library(tidyr)
library(lubridate)
library(here)
library(readxl)
library(readr)
library(stringr)

ssht <- here::here("data/jho_correlation_data.xlsx")
all_sheets <- lapply(excel_sheets(ssht), read_excel, path = ssht)
names(all_sheets)<-excel_sheets(ssht)

cor(all_sheets$`Burrows VCB`[,-1], all_sheets$`Burrows VCB`$`mean burrows`,
    use = "pairwise.complete.obs")
