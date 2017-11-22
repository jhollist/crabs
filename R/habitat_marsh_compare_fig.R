# Code to generate marsh/site crab comparison charts
source("R/functions.R")

crab_data <- read_csv(here("data/crab_data.csv"))

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
            upper_cl = ci_95(value)["ul"]) %>%
  mutate(habitat = fct_relevel(habitat, c("bcb", "vcb", "mp", "iva")))

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
            upper_cl = ci_95(value)["ul"])%>%
  mutate(habitat = fct_relevel(habitat, c("bcb", "vcb", "mp", "iva")))

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
            upper_cl = ci_95(value)["ul"]) %>%
  rbind(data.frame(habitat = c("mp","iva"),
                   mean = c(NA,NA),
                   lower_cl = c(NA,NA),
                   upper_cl = c(NA,NA))) %>%
  mutate(habitat = factor(habitat, c("bcb", "vcb", "mp", "iva")))

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
            upper_cl = ci_95(value)["ul"]) %>%
  rbind(data.frame(habitat = c("iva"),
                   mean = c(NA),
                   lower_cl = c(NA),
                   upper_cl = c(NA))) %>%
  mutate(habitat = factor(habitat, c("bcb", "vcb", "mp", "iva")))
  
  

bh_gg <- crab_bar(burrows_hab_avg, "habitat", y = "Burrow density", 
                  x = "Habitat type", "", breaks = c(0,25,50,75,100,125,150))
bs_gg <- crab_bar(burrows_site_avg, "marsh", y = "Burrow density", 
                  x = "Marsh", "", breaks = c(0,25,50,75,100,125,150))
uh_gg <- crab_bar(uca_habitat_avg, "habitat", y = "Uca CPUE", 
                  x = "Habitat type", "")
us_gg <- crab_bar(uca_site_avg, "marsh", y = "Uca CPUE", 
                  x = "Marsh", "")
sh_gg <- crab_bar(sesarma_habitat_avg, "habitat", y = "Sesarma CPUE", 
                  x = "Habitat type", "")
ss_gg <- crab_bar(sesarma_site_avg, "marsh", y = "Sesarma CPUE", 
                  x = "Marsh", "")
ch_gg <- crab_bar(carcinus_habitat_avg, "habitat", y = "Carcinus CPUE", 
                  x = "Habitat type", "")
cs_gg <- crab_bar(carcinus_site_avg, "marsh", y = "Carcinus CPUE", 
                  x = "Marsh", "")
jpeg("figures/crab_bar_fig.jpg", width = 7.5, height = 10, units = "in", 
     res=300)
grid_arrange_shared_legend(bs_gg, bh_gg, us_gg, uh_gg, 
                           ss_gg, sh_gg, cs_gg, ch_gg, 
                           ncol = 2, nrow = 4, position = "none") 
dev.off()
