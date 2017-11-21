# Review of jwh contributions and suggested changes

# Data

# Correlations

# Anova

- Keep anovas
  - was able to reproduce Table 2. with exception of carcinus.  Slight diferences
  in the F statistic.  Got this with master spreadsheet as source and also with 
  anova spreadsheet as source.  Need to update values in Table 2.
- Drop multiple comparisons and Table 3
  - small sample size for each comparison (only 10)
  - Not sure what it tells us
  - yep, lots of differences between marsh and habitats, but I don't find that
  very interesting.
- anovas re-run in R/anovas.R
- anova results output in results/anova_results.csv

