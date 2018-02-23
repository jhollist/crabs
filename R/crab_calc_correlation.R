# Code to caluclate correlations
source("R/functions.R")

crab_data <- read_csv(here("data/crab_data.csv")) %>%
  filter(variable != "mean_burrows")

crab_correlations <- data.frame()
for(i in unique(crab_data$habitat)){
  crab_correlations <- rbind(calc_correlation(crab_data, i),crab_correlations)
}

# checks (manually change and check against draft)
# All check out except shear_strength, mp, burrow_density
crab_correlations %>%
  filter(habitat == "mp") %>%
  filter(crab_params == "burrow_density")

crab_data %>%
  filter(habitat == "mp") %>%
  spread(variable, value) %>%
  select(marsh, habitat, site_id,burrow_density, shear_strength)

write_csv(crab_correlations, here("results/crab_correlations.csv"))

crab_correlations <- data.frame()
for(i in unique(crab_data$habitat)){
  crab_correlations <- rbind(calc_correlation(crab_data, i, method = "spearman"),crab_correlations)
}

# checks (manually change and check against draft)
# All check out except shear_strength, mp, burrow_density
crab_correlations %>%
  filter(habitat == "mp") %>%
  filter(crab_params == "burrow_density")

crab_data %>%
  filter(habitat == "mp") %>%
  spread(variable, value) %>%
  select(marsh, habitat, site_id,burrow_density, shear_strength)

write_csv(crab_correlations, here("results/crab_correlations_spearman.csv"))
