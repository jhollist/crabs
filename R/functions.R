# All functions used in analysis and viz for Raposa et al.
library(dplyr)
library(tidyr)
library(readr)
library(ggplot2)
library(here)
library(psych)
library(hrbrthemes)
library(gridExtra)
library(grid)
library(readxl)
library(broom)


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
    filter(crab_params == crab) %>%
    mutate(cor_size = 
             case_when(abs(pearson_cor) >= 0 & abs(pearson_cor) < 0.2 ~ 2,
                       abs(pearson_cor) >= 0.2 & abs(pearson_cor) < 0.4 ~ 2.5,
                       abs(pearson_cor) >= 0.4 & abs(pearson_cor) < 0.6 ~ 3,
                       abs(pearson_cor) >= 0.6 & abs(pearson_cor) < 0.8 ~ 3.5),
           cor_color = 
             case_when(pearson_cor < 0 ~ "negative",
                       pearson_cor > 0 ~ "positive",
                       pearson_cor == 0 ~ "zero"))
  gg <-  ggplot(df, aes(x = habitat, y = env_params)) +
    geom_point(aes(size = cor_size, color = pearson_cor)) +
    scale_color_gradient2(name = "Pearson\nCorrelation",
                          low = "darkred", mid = "grey80", high = "darkblue",
                          limits = c(-0.8,0.8),
                          breaks = c(0.8, 0.6, 0.4, 0.2, -0.2, -0.4, -0.6, -0.8),
                          labels = c("0.8 to 0.6", "0.6 to 0.4", "0.4 to 0.2", 
                                     "0.2 to 0", "0 to -0.2", "-0.2 to -0.4",
                                     "-0.4 to -0.6", "-0.6 to -0.8"),
                          guide = guide_legend(override.aes = 
                                    list(size = c(3.5,3,2.5,2,2,2.5,3,3.5)), 
                                    reverse = FALSE,
                                    byrow = TRUE)) +
    scale_size(range = c(2,3.5),guide = FALSE) +
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

grid_arrange_shared_legend <- function(..., ncol = length(list(...)), nrow = 1, 
                                       position = c("bottom", "right", "none")) {
  plots <- list(...)
  #browser()
  position <- match.arg(position)
  g <- ggplotGrob(plots[[1]] + 
                    theme(legend.position = position))$grobs
  if(position != "none"){
    legend <- g[[which(sapply(g, function(x) x$name) == "guide-box")]]
    lheight <- sum(legend$height)
    lwidth <- sum(legend$width)
  }
  gl <- lapply(plots, function(x) x +
                 theme(legend.position = "none"))
  gl <- c(gl, ncol = ncol, nrow = nrow)
  
  combined <- switch(position,
                     "bottom" = arrangeGrob(do.call(arrangeGrob, gl), 
                                            legend,ncol = 1,
                                            heights = unit.c(unit(1, "npc") - lheight, lheight)),
                     "right" = arrangeGrob(do.call(arrangeGrob, gl),
                                           legend, ncol = 2,
                                           widths = unit.c(unit(1, "npc") - lwidth, lwidth)),
                     "none" = arrangeGrob(do.call(arrangeGrob, gl)))
  
  grid.newpage()
  grid.draw(combined)
  
  # return gtable invisibly
  invisible(combined)
}

# Function to develop bar charts comparing crab metrics over habitat and site

crab_bar <- function(df, xval, x = "x", y = "y", title = "title", breaks = 0:5,
                     marg = rep(0.5,4)){
  if(xval == "habitat") {df$xval <- df$habitat}
  if(xval == "marsh") {df$xval <- df$marsh}
  gg <- df %>%
    ggplot(aes(x = xval, y = mean)) +
    geom_bar(stat = "identity", width = 0.5) +
    geom_linerange(aes(ymin = lower_cl, ymax = upper_cl), size = 1.25) +
    theme_ipsum(base_family = "sans") +
    labs(x = x, y = y, title = title) +
    scale_y_continuous(breaks = breaks) +
    expand_limits(y=breaks)+
    theme(plot.title = element_text(size = 14))
  gg$theme$plot.margin <- grid::unit(marg,"line")
  gg
}

# Function to generate most of the temporal plots

temporal_scatter <- function(df, y, title, marg = rep(0.5,4)){
  
  gg <- df %>% 
    ggplot(aes(x = year, y = value, color = group)) +
    geom_point(size = 2.5) +
    geom_smooth(method = "lm", se = FALSE) +
    theme_ipsum(base_family = "sans") +
    labs(x = "Year", y = y, title = title) +
    scale_color_manual(values = c("darkred","darkblue")) +
    theme(legend.title = element_blank(),
          legend.position = c(0.89,0.88),
          legend.background = element_rect(fill = "white", colour = "white"))+
    theme(plot.title = element_text(size = 14))
  gg$theme$plot.margin <- grid::unit(marg,"line")
  gg
}

#' Create Mulitple Plots with ggplots (from Winston Chang)
#' 
#' This is the Multiple plot function from 
#' \href{http://www.cookbook-r.com/Graphs/Multiple_graphs_on_one_page_(ggplot2)}{R-Cookbook}.  
#' I have merely cleaned up some of the params for my use, added some documentation and examples.
#' 
#' @param ... can pass ggplot objects 
#' @param plotlist alternative to ..., list of ggplot objects
#' @param cols Number of columns in layout
#' @param layout A matrix specifying the layout. If present, 'cols' is ignored.
#' If the layout is something like matrix(c(1,2,3,3), nrow=2, byrow=TRUE),
#' then plot 1 will go in the upper left, 2 will go in the upper right, and
#' 3 will go all the way across the bottom.
#' 
#' @examples
#' x<-rnorm(100)
#' y<-jitter(x,10000)
#' img <- readJPEG(system.file('img', 'Rlogo.jpg', package='jpeg'))
#' xdf<-data.frame(x=x,y=y)
#' firstplot<-ggplot(xdf,aes(x=x,y=y))+ geom_point()
#' secondplot<-ggplot(xdf,aes(x=x))+ geom_bar()
#' thirdplot<-ggplot(xdf, aes(x,y)) + 
#' annotation_custom(rasterGrob(img, width=unit(1,'npc'), height=unit(1,'npc')), 
#'                  -Inf, Inf, -Inf, Inf)
#' thirdplot
#' svg("test.svg",width=8)
#' multiplot(thirdplot,secondplot,firstplot,firstplot,layout=matrix(c(1,2,3,4),ncol=4,byrow=F))
#' dev.off()
#' 
#' @export
#' @import ggplot2

multiplot <- function(..., plotlist = NULL, cols = 1, 
                      layout = NULL) {
  require(grid)
  
  # Make a list from the ... arguments and plotlist
  plots <- c(list(...), plotlist)
  
  numPlots = length(plots)
  
  # If layout is NULL, then use 'cols' to determine
  # layout
  if (is.null(layout)) {
    # Make the panel ncol: Number of columns of plots
    # nrow: Number of rows needed, calculated from # of
    # cols
    layout <- matrix(seq(1, cols * ceiling(numPlots/cols)), 
                     ncol = cols, nrow = ceiling(numPlots/cols))
  }
  
  if (numPlots == 1) {
    print(plots[[1]])
    
  } else {
    # Set up the page
    grid.newpage()
    pushViewport(viewport(layout = grid.layout(nrow(layout), 
                                               ncol(layout))))
    
    # Make each plot, in the correct location
    for (i in 1:numPlots) {
      # Get the i,j matrix positions of the regions that
      # contain this subplot
      matchidx <- as.data.frame(which(layout == 
                                        i, arr.ind = TRUE))
      
      print(plots[[i]], vp = viewport(layout.pos.row = matchidx$row, 
                                      layout.pos.col = matchidx$col))
    }
  }
} 

# Function to generate size histograms

size_hist <- function(df, xlab = "Burrow diameter (cm)", var = "burrow_diameter", backdrop = FALSE, 
                      marg = rep(0.5,4), bw = 0.5, title = ""){
  df_all <- df
  df <- df %>%
    filter(variable == var)
  gg <- ggplot(df_all, aes(value))
  if(backdrop){
  gg <- gg  +
      geom_density(aes(y = ..count..), fill = "grey80", color = "grey80", bw = bw)
  }
  gg <- gg +
    geom_density(data = df, aes(value, y = ..count..),fill = "darkblue", color = "darkblue", bw = bw) +
    theme_ipsum(base_family = "sans") +
    labs(x = xlab, title = title) +
    scale_x_continuous(limits = c(0,8)) +
    theme(plot.title = element_text(size = 14))
  gg$theme$plot.margin <- grid::unit(marg,"line")
  gg
}

# Functions for the temporal lm
temporal_lm <- function(df, vars){
  df %>%
    filter(variable == vars) %>%
    lm(value ~ year, data = .) %>%
    glance() %>%
    transmute(test = paste0(vars,"_lm"), p = p.value, stat = r.squared) 
}
