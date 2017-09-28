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
