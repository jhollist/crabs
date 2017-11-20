source("R/functions.R")
crab_data <- read_csv(here("data/crab_data.csv"))

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

carcinus_anova <- crab_data %>%
  filter(variable == "carcinus_cpue")%>%
  mutate(ranks = rank(value)) %>%
  lm(ranks ~ marsh + habitat + marsh:habitat, data = .) %>%
  anova()

sesarma_anova <- crab_data %>%
  filter(variable == "sesarma_cpue")%>%
  mutate(ranks = rank(value)) %>%
  lm(ranks ~ marsh + habitat + marsh:habitat, data = .) %>%
  anova()

broom::tidy(carcinus_anova)

