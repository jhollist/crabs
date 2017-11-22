source(here("R/functions.R"))

temporal_data <- read_csv(here("data/temporal_data.csv"))

# A. 1998 to 2016

a <- temporal_data %>%
  filter(variable == "burrow_density") %>%
  mutate(habitat = case_when(habitat == "low" ~ "Creekbank",
                             habitat == "high" ~ "Marsh Platform")) %>%
  group_by(year, habitat) %>%
  summarize(mean_bd = mean(value),
            lower_cl = ci_95(value)["ll"],
            upper_cl = ci_95(value)["ul"]) %>%
  ggplot(aes(x = habitat, y = mean_bd, group = year)) +
  geom_bar(stat = "identity", width = 0.35, position = position_dodge(width = 0.5)) +
  geom_linerange(aes(ymin = lower_cl, ymax = upper_cl), 
                 size = 1.25, position = position_dodge(width = 0.5)) +
  theme_ipsum(base_family = "sans") +
  labs(x = "", y = "Burrow density", title = "A.") + 
  scale_x_discrete(position = "top") +
  annotate("text", x=c(0.875,1.125,1.875,2.125), y=-5, 
           label= c("1998","2016", "1998","2016"),
           color = "grey30", size = 3.5, family = "sans") 


# B. Extent bare creekbank

b <- temporal_data %>%
  filter(grepl("extent_bare",variable)) %>%
  mutate(group = case_when(site_id == "cogg" ~ "Coggeshall",
                             site_id == "nag" ~ "Nag West",
                             TRUE ~ site_id)) %>%
  temporal_scatter(y = bquote("Extent of bare creekbank (m"^"2)"), title = "B.") +
  theme(legend.position = c(0.2,0.85))

# C. Fishing effort

c <- temporal_data %>%
  filter(grepl("fishing_effort",variable)) %>%
  mutate(group = 
           case_when(variable == "fishing_effort_all_predators" ~ "All crustacean\npredators",
                     variable == "fishing_effort_striped_bass" ~ "Striped Bass",
                     TRUE ~ variable),
         value = value/1000) %>%
  temporal_scatter(y = "Total # of fishing trips (in 1000s)", title = "C.") +
  theme(legend.position = c(0.2,0.2))

# D. Birds

d <- temporal_data %>%
  filter(grepl("wad",variable)) %>%
  mutate(group = 
           case_when(variable == "all_wading_birds" ~ "All marsh waders",
                     variable == "crustacean_eating_waders" ~ "GLIB and BCNH",
                     TRUE ~ variable)) %>%
  temporal_scatter(y = "Number of nests", title = "D.") +
  theme(legend.position = c(0.75,0.85))

# E. Osprey Nests

e <- temporal_data %>%
  filter(grepl("osprey",variable)) %>%
  mutate(group = "Osprey nests") %>%
  temporal_scatter(y = "Number of Osprey nests", title = "E.") +
  theme(legend.position =  "none")

# F. Water Level

f <- temporal_data %>%
  filter(grepl("high_water",variable)) %>%
  mutate(group = "Mean high water") %>%
  temporal_scatter(y = "Mean high water(m NAVD 88)", title = "F.") +
  theme(legend.position =  "none")

# G. Temperature

g <- temporal_data %>%
  filter(grepl("temperature",variable)) %>%
  mutate(group = "Water temperature") %>%
  temporal_scatter(y = "Water temperature (C)", title = "G.") +
  theme(legend.position =  "none")

a$theme$plot.margin <- b$theme$plot.margin

jpeg("figures/temporal_fig.jpg", width = 7.5, height = 10, units = "in", 
     res=300)
multiplot(a,c,e,b,d,f, cols = 2)
dev.off()
