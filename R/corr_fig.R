# Code to generate corrlation matrix figure
source("R/functions.R")

crab_correlations <- read_csv(here("results/crab_correlations.csv"))

hab_order <- c("bcb", "vcb", "mp", "iva")
env_order <- c("Cover - SPAALT","Cover - SPAPAT","Cover - DISSPI",
               "Cover - JUNGER","Cover - IVAFRU", "Cover - Bare", 
               "Height - SPAALT","Height - SPAPAT", "Height - DISSPI", 
               "Height - JUNGER","Elevation","Bulk density",
               "% moisture","% organic","Shear strength")
env_order <- env_order[length(env_order):1]

# This is fucked up.
crab_correlations <- crab_correlations %>%
  mutate(habitat = fct_relevel(factor(habitat,hab_order), hab_order),
         env_params = fct_relevel(factor(env_params, labels = env_order), env_order))

bd_gg <- cor_fig(crab_correlations,"burrow_density", 
                 expression(paste("A. Burrow Density")))

uca_gg <- cor_fig(crab_correlations,"uca_cpue", 
                  expression(paste("B. ", italic("Uca"), " CPUE")))

carc_gg <- cor_fig(crab_correlations,"carcinus_cpue", 
                   expression(paste("C. ", italic("Carcinus"), " CPUE")))

ses_gg <- cor_fig(crab_correlations,"sesarma_cpue", 
                  expression(paste("D. ", italic("Sesarma"), " CPUE")))

jpeg(here("figures/crab_cor_fig.jpg"), width = 6, height = 6.25, units = "in",
     res=300)
grid_arrange_shared_legend(bd_gg, uca_gg, carc_gg, ses_gg, ncol = 2, nrow = 2)
dev.off()
  
  

 

  


