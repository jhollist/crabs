# Sample sizes per marsh and habitat type
source(here::here("R/functions.R"))
crab_data <- read_csv(here("data/crab_data.csv")) %>%
  mutate(value = round(value,5))

corr_df <- crab_data %>%
  spread(variable, value)

# Burrow Density Sample Size
crab_data %>%
  spread(variable, value) %>%
  select(burrow_density, carcinus_cpue, sesarma_cpue, uca_cpue, everything()) %>%
  gather(variable,value,8:23) %>%
  group_by(marsh,habitat,variable) %>%
  summarize(n = n()) 

# Pooled data assumptions
crab_pearson <- read_csv("results/crab_correlations.csv") %>%
  select(habitat, crab_params, env_params, pearson = correlation)
crab_spearman <- read_csv("results/crab_correlations_spearman.csv") %>%
  select(habitat, crab_params, env_params, spearman = correlation)

p_s_gg <- crab_pearson %>%
  left_join(crab_spearman) %>%
  ggplot(aes(x=pearson, y=spearman)) +
  geom_point() +
  geom_abline() + 
  facet_wrap(crab_params ~ habitat)
ggsave(p_s_gg, "figures/pearson_spearman.jpg", width = 5, height = 5, 
       units = "in")

crab_pearson %>%
  left_join(crab_spearman) %>%
  filter(complete.cases(.)) %>%
  group_by(habitat,crab_params) %>%
  summarize(corr_mean_diff = round(mean(pearson - spearman),2)) %>%
  knitr::kable()
