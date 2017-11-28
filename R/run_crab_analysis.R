# This script runs the full analysis, creates figures, and generates results
library(here)

# Data preparation - not needed (hence commented out) as input csv files already
# exist in data/
# source(here("R/data_prep_master.R"))
# source(here("R/data_prep_temporal.R"))
# source(here("R/data_prep_size.R"))

# Run ANOVA
source(here("R/anovas.R"))

# Run correlations
source(here("R/crab_calc_correlation.R"))

# Generate figures
source(here("R/corr_fig.R"))
source(here("R/habitat_marsh_compare_fig.R"))
source(here("R/temporal_fig.R"))
source(here("R/size_fig.R"))
