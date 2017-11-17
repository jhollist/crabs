# All functions used in analysis and viz for Raposa et al.
library(tidyverse)
library(here)
library(psych)
library(hrbrthemes)
library(viridis)
library(gridExtra)
library(grid)
library(readxl)

# 95% Confidence Intervals of a vector
ci_95 <- function(x){
  se <- sd(x)/sqrt(length(x))
  c(ll=mean(x) - (2*se),
    ul=mean(x)+(2*se))
}

# Function to calculate correlation coef from crab_data csv
calc_correlation <- function(xdf, hab){
  parse_it <- function(df){
    df %>%
      mutate(variables = row.names(.)) %>%
      select(variables,burrow_density,carcinus_cpue,sesarma_cpue,uca_cpue) %>%
      filter(variables != "burrow_density",
             variables != "carcinus_cpue",
             variables != "sesarma_cpue",
             variables != "uca_cpue") %>%
      mutate(habitat = hab)
  }
  
  corr_df <- xdf %>%
    spread(variable, value) %>%
    filter(habitat == hab) %>%
    select(-habitat,-site_id, -marsh) %>%
    corr.test(use="pairwise", adjust = "none")
  
  r <- data.frame(corr_df$r) %>%
    parse_it() %>%
    gather(crab_params, pearson_cor,2:5) %>%
    select(habitat,crab_params, env_params = variables, pearson_cor)
  n <- data.frame(corr_df$n) %>%
    parse_it() %>%
    gather(crab_params, n,2:5) %>%
    select(habitat,crab_params, env_params = variables, n)
  p <- data.frame(corr_df$p) %>%
    parse_it() %>%
    gather(crab_params, p,2:5) %>%
    select(habitat,crab_params, env_params = variables, p)
  
  left_join(r,n) %>%
    left_join(p)
}

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
    theme(text = element_text(size = 8),
          #legend.text = element_text(size = 10),
          plot.margin = grid::unit(c(0,0,0,0),"line"),
          plot.title = element_text(hjust = 0, size = 9, 
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

# Function to develop bar charts comparing crab metrics over habitat and site

crab_bar <- function(df, x = "x", y = "y", title = "title"){
  df %>%
    ggplot(aes(x = habitat, y = mean)) +
    geom_bar(stat = "identity") +
    geom_linerange(aes(ymin = lower_cl, ymax = upper_cl), color = viridis(1)) +
    theme_ipsum(base_family = "sans")
}