source("R/functions.R")
crab_data <- read_csv(here("data/crab_data.csv")) %>%
  mutate(value = round(value,5))

bd_anova <- crab_data %>%
  filter(variable == "burrow_density")%>%
  mutate(ranks = rank(value)) %>%
  lm(ranks ~ marsh + habitat + marsh:habitat, data = .) %>%
  anova()

uca_anova <- crab_data %>%
  filter(variable == "uca_cpue")%>%
  mutate(ranks = rank(value)) %>%
  lm(ranks ~ marsh + habitat + marsh:habitat, data = .) %>%
  anova()

carcinus_anova <- carb_data %>%
  filter(variable == "carcinus_cpue")%>%
  mutate(ranks = rank(value)) %>%
  lm(ranks ~ marsh + habitat + marsh:habitat, data = .) %>%
  anova()

sesarma_anova <- crab_data %>%
  filter(variable == "sesarma_cpue")%>%
  mutate(ranks = rank(value)) %>%
  lm(ranks ~ marsh + habitat + marsh:habitat, data = .) %>%
  aov()

anova_results <- rbind(cbind(crab_param = "burrow_density",broom::tidy(bd_anova)),
                       cbind(crab_param = "uca_cpue",broom::tidy(uca_anova)),
                       cbind(crab_param = "carcinus_cpue",broom::tidy(carcinus_anova)),
                       cbind(crab_param = "sesarma_cpue",broom::tidy(sesarma_anova)))
write_csv(anova_results,here("results/anova_results.csv"))
