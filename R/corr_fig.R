library(tidyverse)
library(here)
library(ggplot2)
library(hrbrthemes)
library(forcats)
library(viridis)
library(readr)


## Function to build correlation matrix

cor_fig <- function(df, crab, title = "Correlation Matrix"){
  
  df <- crab_correlations %>%
    filter(crab_params == crab) %>%
    mutate(habitat = fct_relevel(factor(habitat), hab_order),
           env_params = fct_relevel(factor(env_params), env_order))
  
  gg <-  ggplot(df, aes(x = habitat, y = env_params)) +
    geom_point(aes(size = abs(pearson_cor), color = pearson_cor)) + 
    scale_color_viridis(name = "Pearson's\ncorrelation", 
                        limits = c(-1,1), #range(cor_df_long$value), 
                        breaks = c(1.0, 0.5, 0.0, -0.5, -1.0) ,#round(seq(max(cor_df_long$value), min(cor_df_long$value), length.out = 5), 2),
                        guide = guide_legend(override.aes = 
                                               list(size = c(5,2.5,1,2.5,5)), 
                                             reverse = FALSE)) +
    scale_size(range = c(1,5), guide = FALSE) +
    theme_ipsum() +
    scale_x_discrete(position = "top") +
    labs(x = "", y = "", title = title) +
    theme(legend.text = element_text(size = 10),
          plot.margin = grid::unit(c(0,0,0,0),"line"),
          plot.title = element_text(hjust = 0, size = 10, 
                                    margin = margin(t = 2, b=-5, unit="pt")),
          axis.text.x = element_text(angle= 45, hjust = 0),
          legend.key.width=unit(2, "line"), 
          legend.key.height=unit(1.5, "line"))
  gg
}


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

crab_correlations <- read_csv(here("results/crab_correlations.csv"))

hab_order <- c("bcb", "vcb", "mp", "iva")
env_order <- c("cover_spaalt","cover_spapat","cover_disspi","cover_junger",
               "cover_ivafru", "bare", "height_spaalt","height_spapat",
               "height_disspi", "height_junger","elevation","bulk_density",
               "perc_moisture","perc_organic","shear_strength")
env_order <- env_order[length(env_order):1]

bd_gg <- cor_fig(crab_correlations,"burrow_density", 
                 expression(paste("A. Burrow Density")))
uca_gg <- cor_fig(crab_correlations,"uca_cpue", 
                  expression(paste("B. ", italic("Uca"), " CPUE")))
carc_gg <- cor_fig(crab_correlations,"carcinus_cpue", 
                   expression(paste("C. ", italic("Carcinus"), " CPUE")))
ses_gg <- cor_fig(crab_correlations,"sesarma_cpue", 
                  expression(paste("D. ", italic("Sesarma"), " CPUE")))

jpeg(here("figures/crab_cor_fig.jpg"), width = 7, height = 7, units = "in",res=300)
multiplot(bd_gg, carc_gg, uca_gg, ses_gg, cols = 2)
dev.off()
  
  
 

  


