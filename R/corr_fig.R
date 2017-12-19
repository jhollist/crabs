# Code to generate corrlation matrix figure
source("R/functions.R")


crab_correlations <- read_csv(here("results/crab_correlations.csv"))

hab_order <- c("bcb", "vcb", "mp", "iva")
env <- c("Cover - Bare", "Bulk density", "Cover - DISSPI", "Cover - IVAFRU",
         "Cover - JUNGER", "Cover - SPAALT", "Cover - SPAPAT","Elevation",
         "Height - DISSPI","Height - JUNGER", "Height - SPAALT",
         "Height - SPAPAT", "% moisture","% organic","Shear strength")
env_order <- c("Cover - SPAALT","Cover - SPAPAT","Cover - DISSPI",
               "Cover - JUNGER","Cover - IVAFRU", "Cover - Bare", 
               "Height - SPAALT","Height - SPAPAT", "Height - DISSPI", 
               "Height - JUNGER","Elevation","Bulk density",
               "% moisture","% organic","Shear strength")
env_order <- env_order[length(env_order):1]

# Also Filtering out correlations for which we had a small sample size
# Less than 10 in this case.
crab_correlations <- crab_correlations %>%
  mutate(habitat = fct_relevel(factor(habitat),hab_order),
         env_params = fct_relevel(factor(crab_correlations$env_params,
                                         labels = env), env_order))  %>%
  filter(n >= 10)

bd_gg <- cor_fig(crab_correlations,"burrow_density", 
                 expression(paste("A. Burrow Density")))

uca_gg <- cor_fig(crab_correlations,"uca_cpue", 
                  expression(paste("B. ", italic("Uca"), " CPUE")))

carc_gg <- cor_fig(crab_correlations,"carcinus_cpue", 
                   expression(paste("C. ", italic("Carcinus"), " CPUE")))

ses_gg <- cor_fig(crab_correlations,"sesarma_cpue", 
                  expression(paste("D. ", italic("Sesarma"), " CPUE")))

titles <- ggplot() + 
  labs(title = "Correlations between crab abundance indicators and environmental
       parameters in four habitat types.",
       subtitle = "Refer to the text for habitat acronyms. For vegetation, 
       SPAALT=Spartina alterniflora, SPAPAT=Spartina patens, 
       DISSPI=Distichlis spicata, JUNGER=Juncus gerardii, and 
       IVAFRU=Iva frutescens. Correlations run for pairs with 10 or more 
       samples.") + theme_void()

# Correlations between crab abundance indicators and environmental parameters in four habitat types.

# Refer to the text for habitat acronyms. For vegetation, SPAALT=Spartina alterniflora, SPAPAT=Spartina patens, DISSPI=Distichlis spicata, JUNGER=Juncus gerardii, and IVAFRU=Iva frutescens. Correlations run for pairs with 10 or more samples.

pdf(here("figures/figure4.pdf"), width = 6, height = 6.25, onefile = FALSE)
x<-grid_arrange_shared_legend(bd_gg, uca_gg, carc_gg, ses_gg, ncol = 2, nrow = 2)
dev.off()
  
  

 

  


