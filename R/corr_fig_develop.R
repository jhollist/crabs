library(tidyverse)
library(here)
library(ggplot2)
library(hrbrthemes)
library(forcats)

crab_correlations <- read_csv(here("results/crab_correlations.csv"))

hab_order <- c("bcb", "vcb", "mp", "iva")
env_order <- c("cover_spaalt","cover_spapat","cover_disspi","cover_junger",
               "cover_ivafru", "bare", "height_spaalt","height_spapat",
               "height_disspi", "height_junger","elevation","bulk_density",
               "perc_moisture","perc_organic","shear_strength")
env_order <- env_order[length(env_order):1]

crab_correlations_bd <- crab_correlations %>%
  filter(crab_params == "burrow_density") %>%
  mutate(habitat = fct_relevel(factor(habitat), hab_order),
         env_params = fct_relevel(factor(env_params), env_order))

cor_gg_bd <- ggplot(crab_correlations_bd, aes(x = habitat, y = env_params)) +
  geom_point(aes(size = abs(pearson_cor), color = pearson_cor)) + 
  scale_color_viridis_c(name = "Pearson's\ncorrelation", 
                        limits = c(-1,1), #range(cor_df_long$value), 
                        breaks = c(1.0, 0.5, 0.0, -0.5, -1.0) ,#round(seq(max(cor_df_long$value), min(cor_df_long$value), length.out = 5), 2),
                        guide = guide_legend(override.aes = 
                                               list(size = c(5,2.5,1,2.5,5)), 
                                             reverse = FALSE)) +
  scale_size(range = c(1,5), guide = FALSE) +
  theme_ipsum() +
  scale_x_discrete(position = "top") +
  labs(x = "", y = "", title = "A. Burrow Density") +
  theme(legend.text = element_text(size = 10),
        axis.text.x = element_text(angle= 45, hjust = 0))
cor_gg_bd

crab_correlations_uca <- crab_correlations %>%
  filter(crab_params == "uca_cpue") %>%
  mutate(habitat = fct_relevel(factor(habitat), hab_order),
         env_params = fct_relevel(factor(env_params), env_order))

cor_gg_uca <- ggplot(crab_correlations_uca, aes(x = habitat, y = env_params)) +
  geom_point(aes(size = abs(pearson_cor), color = pearson_cor)) + 
  scale_color_viridis_c(name = "Pearson's\ncorrelation", 
                        limits = c(-1,1), #range(cor_df_long$value), 
                        breaks = c(1.0, 0.5, 0.0, -0.5, -1.0) ,#round(seq(max(cor_df_long$value), min(cor_df_long$value), length.out = 5), 2),
                        guide = guide_legend(override.aes = 
                                               list(size = c(5,2.5,1,2.5,5)), 
                                             reverse = FALSE)) +
  scale_size(range = c(1,5), guide = FALSE) +
  theme_ipsum() +
  scale_x_discrete(position = "top") +
  labs(x = "", y = "", title = expression(paste("B. ", italic("Uca"), " CPUE"))) +
  theme(legend.text = element_text(size = 10),
        axis.text.x = element_text(angle= 45, hjust = 0))
cor_gg_uca

crab_correlations_carc <- crab_correlations %>%
  filter(crab_params == "carcinus_cpue") %>%
  mutate(habitat = fct_relevel(factor(habitat), hab_order),
         env_params = fct_relevel(factor(env_params), env_order))

cor_gg_carc <- ggplot(crab_correlations_carc, aes(x = habitat, y = env_params)) +
  geom_point(aes(size = abs(pearson_cor), color = pearson_cor)) + 
  scale_color_viridis_c(name = "Pearson's\ncorrelation", 
                        limits = c(-1,1), #range(cor_df_long$value), 
                        breaks = c(1.0, 0.5, 0.0, -0.5, -1.0) ,#round(seq(max(cor_df_long$value), min(cor_df_long$value), length.out = 5), 2),
                        guide = guide_legend(override.aes = 
                                               list(size = c(5,2.5,1,2.5,5)), 
                                             reverse = FALSE)) +
  scale_size(range = c(1,5), guide = FALSE) +
  theme_ipsum() +
  scale_x_discrete(position = "top") +
  labs(x = "", y = "", title = expression(paste("C. ", italic("Carcinus"), " CPUE"))) +
  theme(legend.text = element_text(size = 10),
        axis.text.x = element_text(angle= 45, hjust = 0))
cor_gg_carc

crab_correlations_ses <- crab_correlations %>%
  filter(crab_params == "sesarma_cpue") %>%
  mutate(habitat = fct_relevel(factor(habitat), hab_order),
         env_params = fct_relevel(factor(env_params), env_order))

cor_gg_ses <- ggplot(crab_correlations_ses, aes(x = habitat, y = env_params)) +
  geom_point(aes(size = abs(pearson_cor), color = pearson_cor)) + 
  scale_color_viridis_c(name = "Pearson's\ncorrelation", 
                        limits = c(-1,1), #range(cor_df_long$value), 
                        breaks = c(1.0, 0.5, 0.0, -0.5, -1.0) ,#round(seq(max(cor_df_long$value), min(cor_df_long$value), length.out = 5), 2),
                        guide = guide_legend(override.aes = 
                                               list(size = c(5,2.5,1,2.5,5)), 
                                             reverse = FALSE)) +
  scale_size(range = c(1,5), guide = FALSE) +
  theme_ipsum() +
  scale_x_discrete(position = "top") +
  labs(x = "", y = "", title = expression(paste("D. ", italic("Sesarma"), " CPUE"))) +
  theme(legend.text = element_text(size = 10),
        axis.text.x = element_text(angle= 45, hjust = 0))
cor_gg_ses

# Multiple plot function
#
# ggplot objects can be passed in ..., or to plotlist (as a list of ggplot objects)
# - cols:   Number of columns in layout
# - layout: A matrix specifying the layout. If present, 'cols' is ignored.
#
# If the layout is something like matrix(c(1,2,3,3), nrow=2, byrow=TRUE),
# then plot 1 will go in the upper left, 2 will go in the upper right, and
# 3 will go all the way across the bottom.
#
multiplot <- function(..., plotlist=NULL, file, cols=1, layout=NULL) {
  library(grid)
  
  # Make a list from the ... arguments and plotlist
  plots <- c(list(...), plotlist)
  
  numPlots = length(plots)
  
  # If layout is NULL, then use 'cols' to determine layout
  if (is.null(layout)) {
    # Make the panel
    # ncol: Number of columns of plots
    # nrow: Number of rows needed, calculated from # of cols
    layout <- matrix(seq(1, cols * ceiling(numPlots/cols)),
                     ncol = cols, nrow = ceiling(numPlots/cols))
  }
  
  if (numPlots==1) {
    print(plots[[1]])
    
  } else {
    # Set up the page
    grid.newpage()
    pushViewport(viewport(layout = grid.layout(nrow(layout), ncol(layout))))
    
    # Make each plot, in the correct location
    for (i in 1:numPlots) {
      # Get the i,j matrix positions of the regions that contain this subplot
      matchidx <- as.data.frame(which(layout == i, arr.ind = TRUE))
      
      print(plots[[i]], vp = viewport(layout.pos.row = matchidx$row,
                                      layout.pos.col = matchidx$col))
    }
  }
}

multiplot(cor_gg_bd, cor_gg_uca, cor_gg_carc, cor_gg_ses, cols = 2)

  
  
 

  


