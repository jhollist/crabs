# Packages
library(sf)
#library(quickmapr)
library(mapview)
library(here)
library(tidyverse)

# Get shapefile of marshes
# download.file("http://www.rigis.org/geodata/bio/saltmarsh12.zip",
#              destfile = "data/saltmarsh.zip")
# unzip("data/saltmarsh.zip",exdir = "data")
saltmarsh12 <- st_read(here("data/saltmarsh12.shp"))

biss <- st_read(here("data/bissel.shp")) %>%
  mutate(marsh = "biss") %>%
  select(id = Id, marsh) %>%
  mutate(tot_area = st_area(.) ) %>%
  group_by(marsh) %>%
  summarize(tot_area = sum(tot_area))

biss_idx <- biss %>% 
  st_intersects(saltmarsh12) %>%
  unlist

cogg <- st_read(here("data/coggeshall_w_Iva.shp")) %>% 
  mutate(marsh = "cogg") %>%
  select(id = Id, marsh) %>%
  mutate(tot_area = st_area(.) ) %>%
  group_by(marsh) %>%
  summarize(tot_area = sum(tot_area))

nag <- st_read(here("data/nag_bound.shp")) %>%
  mutate(marsh = "nag") %>%
  select(id = Id, marsh) %>%
  mutate(tot_area = st_area(.) ) %>%
  group_by(marsh) %>%
  summarize(tot_area = sum(tot_area))

pass <- st_read(here("data/pass.shp")) %>%
  mutate(marsh = "pass") %>%
  select(id = Id, marsh) %>%
  mutate(tot_area = st_area(.) ) %>%
  group_by(marsh) %>%
  summarize(tot_area = sum(tot_area))

crab_marsh_hab <- crab_marsh_bnd %>%
  st_union(saltmarsh12)
