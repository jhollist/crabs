library(tidyverse)
library(here)
library(ggplot2)
library(hrbrthemes)
library(forcats)
library(viridis)
library(readr)
library(gridExtra)
library(grid)


## Function to build correlation matrix

cor_fig <- function(df, crab, title = "Correlation Matrix", ...){
  df <- df %>%
    filter(crab_params == crab)
  gg <-  ggplot(df, aes(x = habitat, y = env_params)) +
    geom_point(aes(size = abs(pearson_cor), color = pearson_cor)) + 
    scale_color_viridis(name = "Pearson's\ncorrelation", 
                        limits = c(-1,1), #range(cor_df_long$value), 
                        breaks = c(1.0, 0.5, 0.0, -0.5, -1.0) ,#round(seq(max(cor_df_long$value), min(cor_df_long$value), length.out = 5), 2),
                        guide = guide_legend(override.aes = 
                                               list(size = c(5,2.5,1,2.5,5)), 
                                             reverse = FALSE)) +
    scale_size(range = c(1,5), guide = FALSE) +
    theme_ipsum(base_family = "sans") +
    scale_x_discrete(position = "top") +
    labs(x = "", y = "", title = title) +
    theme(legend.text = element_text(size = 10),
          plot.margin = grid::unit(c(0,0,0,0),"line"),
          plot.title = element_text(hjust = 0, size = 10, 
                                    margin = margin(t = 2, b=-5, unit="pt")),
          axis.text.x = element_text(angle= 45, hjust = 0),
          legend.key.width=unit(2, "line"), 
          legend.key.height=unit(1.5, "line"),
          legend.position = "bottom",
          axis.text.y = element_text(hjust = 0)) 
  gg
}

# Arranges ggplots with a shared legend
# Source: https://github.com/tidyverse/ggplot2/wiki/share-a-legend-between-two-ggplot2-graphs

grid_arrange_shared_legend <- function(..., ncol = length(list(...)), nrow = 1, position = c("bottom", "right")) {
  plots <- list(...)
  position <- match.arg(position)
  g <- ggplotGrob(plots[[1]] + 
                    theme(legend.position = position))$grobs
  legend <- g[[which(sapply(g, function(x) x$name) == "guide-box")]]
  lheight <- sum(legend$height)
  lwidth <- sum(legend$width)
  gl <- lapply(plots, function(x) x +
                 theme(legend.position = "none"))
  gl <- c(gl, ncol = ncol, nrow = nrow)
  
  combined <- switch(position,
                     "bottom" = arrangeGrob(do.call(arrangeGrob, gl), 
                                            legend,ncol = 1,
                                            heights = unit.c(unit(1, "npc") - lheight, lheight)),
                     "right" = arrangeGrob(do.call(arrangeGrob, gl),
                                           legend, ncol = 2,
                                           widths = unit.c(unit(1, "npc") - lwidth, lwidth)))
  
  grid.newpage()
  grid.draw(combined)
  
  # return gtable invisibly
  invisible(combined)
}


crab_correlations <- read_csv(here("results/crab_correlations.csv"))

hab_order <- c("bcb", "vcb", "mp", "iva")
env_order <- c("Cover - SPAALT","Cover - SPAPAT","Cover - DISSPI",
               "Cover - JUNGER","Cover - IVAFRU", "Cover - Bare", 
               "Height - SPAALT","Height - SPAPAT", "Height - DISSPI", 
               "Height - JUNGER","Elevation","Bulk density",
               "% moisture","% organic","Shear strength")
env_order <- env_order[length(env_order):1]

crab_correlations <- crab_correlations %>%
  mutate(habitat = fct_relevel(factor(habitat,labels = hab_order), hab_order),
         env_params = fct_relevel(factor(env_params, labels = env_order), env_order))

bd_gg <- cor_fig(crab_correlations,"burrow_density", 
                 expression(paste("A. Burrow Density")))

uca_gg <- cor_fig(crab_correlations,"uca_cpue", 
                  expression(paste("B. ", italic("Uca"), " CPUE")))

carc_gg <- cor_fig(crab_correlations,"carcinus_cpue", 
                   expression(paste("C. ", italic("Carcinus"), " CPUE")))

ses_gg <- cor_fig(crab_correlations,"sesarma_cpue", 
                  expression(paste("D. ", italic("Sesarma"), " CPUE")))

jpeg(here("figures/crab_cor_fig.jpg"), width = 7, height = 7, units = "in",
     res=300)
grid_arrange_shared_legend(bd_gg, uca_gg, carc_gg, ses_gg, ncol = 2, nrow = 2)
dev.off()
  
  

 

  


