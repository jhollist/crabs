# Code to generate marsh/site crab comparison charts
source("R/functions.R")

crab_data <- read_csv(here("data/crab_corr_data.csv"))

burrows_site_avg <- crab_data %>%
  filter(variable == "burrow_density") %>%
  group_by(marsh) %>%
  summarize(mean = mean(value),
            lower_cl = ci_95(value)["ll"],
            upper_cl = ci_95(value)["ul"])

burrows_hab_avg <- crab_data %>%
  filter(variable == "burrow_density") %>%
  group_by(habitat) %>%
  summarize(mean = mean(value),
            lower_cl = ci_95(value)["ll"],
            upper_cl = ci_95(value)["ul"])

uca_site_avg <- crab_data %>%
  filter(variable == "uca_cpue") %>%
  group_by(marsh) %>%
  summarize(mean = mean(value),
            lower_cl = ci_95(value)["ll"],
            upper_cl = ci_95(value)["ul"])

uca_habitat_avg <- crab_data %>%
  filter(variable == "uca_cpue") %>%
  group_by(habitat) %>%
  summarize(mean = mean(value),
            lower_cl = ci_95(value)["ll"],
            upper_cl = ci_95(value)["ul"])

sesarma_site_avg <- crab_data %>%
  filter(variable == "sesarma_cpue") %>%
  group_by(marsh) %>%
  summarize(mean = mean(value),
            lower_cl = ci_95(value)["ll"],
            upper_cl = ci_95(value)["ul"])

sesarma_habitat_avg <- crab_data %>%
  filter(variable == "sesarma_cpue") %>%
  group_by(habitat) %>%
  summarize(mean = mean(value),
            lower_cl = ci_95(value)["ll"],
            upper_cl = ci_95(value)["ul"])

carcinus_site_avg <- crab_data %>%
  filter(variable == "carcinus_cpue") %>%
  group_by(marsh) %>%
  summarize(mean = mean(value),
            lower_cl = ci_95(value)["ll"],
            upper_cl = ci_95(value)["ul"])

carcinus_habitat_avg <- crab_data %>%
  filter(variable == "carcinus_cpue") %>%
  group_by(habitat) %>%
  summarize(mean = mean(value),
            lower_cl = ci_95(value)["ll"],
            upper_cl = ci_95(value)["ul"])

bh_gg <- crab_bar(burrows_hab_avg)




bs_gg <- burrows_site_avg
uh_gg <- uca_habitat_avg
us_gg <- uca_site_avg
sh_gg <- sesarma_habitat_avg
ss_gg <- sesarma_site_avg
ch_gg <- carcinus_habitat_avg
cs_gg <- carcinus_site_avg
