crab_data <- read_csv(here("data/crab_data.csv"))

crab_data_wide <- crab_data %>%
    mutate(site_id = paste(marsh, habitat, site_id, sep = "_")) %>%
  select(-marsh) %>%
  spread(variable, value) %>%
  select(site_id, habitat, bare:uca_cpue) %>%
  mutate(bare = case_when(habitat == "bcb" ~ 100,
                                  TRUE ~ bare),
         cover_disspi = case_when(is.na(cover_disspi) ~ 0,
                                  TRUE ~ cover_disspi),
         cover_ivafru = case_when(is.na(cover_ivafru) ~ 0,
                                  TRUE ~ cover_ivafru),
         cover_junger = case_when(is.na(cover_junger) ~ 0,
                                  TRUE ~ cover_junger),
         cover_spaalt = case_when(is.na(cover_spaalt) ~ 0,
                                  TRUE ~ cover_spaalt),
         cover_spapat = case_when(is.na(cover_spapat) ~ 0,
                                  TRUE ~ cover_spapat),
         height_disspi = case_when(is.na(height_disspi) ~ 0,
                                  TRUE ~ height_disspi),
         height_junger = case_when(is.na(height_junger) ~ 0,
                                  TRUE ~ height_junger),
         height_spaalt = case_when(is.na(height_spaalt) ~ 0,
                                  TRUE ~ height_spaalt),
         height_spapat = case_when(is.na(height_spapat) ~ 0,
                                  TRUE ~ height_spapat),
         habitat = factor(habitat))
bd_rf <- crab_data_wide %>%
  select(-uca_cpue,-carcinus_cpue,-sesarma_cpue, -site_id) %>%
  na.omit() %>%
  randomForest::randomForest(burrow_density ~ ., data = ., importance = TRUE)

uca_rf <- crab_data_wide %>%
  select(-uca_cpue,-carcinus_cpue,-sesarma_cpue, -site_id) %>%
  na.omit() %>%
  randomForest::randomForest(burrow_density ~ ., data = ., importance = TRUE)
