source("R/functions.R")

temporal_data <- read_csv(here("data/temporal_data.csv"))

# t-tests

bd_cb_ttest <- temporal_data %>%
  filter(variable == "burrow_density",
         habitat == "low") %>%
  t.test(value ~ year, data = .) %>%
  tidy() %>%
  transmute(test =  "burrow_density_cb_ttest",p = p.value, stat = statistic)

bd_mp_ttest <- temporal_data %>%
  filter(variable == "burrow_density",
         habitat == "high") %>%
  t.test(value ~ year, data = .) %>%
  tidy() %>%
  transmute(test = "burrow_density_mp_ttest", p = p.value, stat = statistic)


# bare creek regressions
bcb_cogg_lm <- temporal_data %>%
  temporal_lm("extent_bare_creekbank_cogg")

bcb_nag_lm <- temporal_data %>%
  temporal_lm("extent_bare_creekbank_nag")

# rec fishing regression

all_fish_lm <- temporal_data %>%
  temporal_lm("fishing_effort_all_predators") 

sb_fish_lm <- temporal_data %>%
  temporal_lm("fishing_effort_striped_bass") 

# bird regression

all_birds_lm <- temporal_data %>%
  temporal_lm("all_wading_birds")

crusty_birds_lm <- temporal_data %>%
  temporal_lm("crustacean_eating_waders") 

# osprey regressions

osprey_lm <- temporal_data %>%
  temporal_lm("osprey_nests") 

# mean_high_water level regressions

tide_lm <- temporal_data %>%
  temporal_lm("mean_high_water")

temporal_results <- rbind(bd_cb_ttest, bd_mp_ttest, bcb_cogg_lm, bcb_nag_lm, all_fish_lm, 
      sb_fish_lm, all_birds_lm, crusty_birds_lm, osprey_lm,tide_lm)

write_csv(temporal_results, here("results/temporal_results.csv"))
