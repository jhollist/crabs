# Review of jwh contributions and suggested changes

# Data
- I had access to several datasets
  - Master crab and env spreadsheet
  - Temporal data spreadsheet
  - jho correlation data spreadsheet
  - anova spreadsheets sent to Beth
  - crab size distribution
- Small differences in the various sources complicated reproducing the exact
results in the original draft paper.  So that results are consistent, I started 
with the Master spreadsheet, pulled those data into R and cleaned that dataset
- Need to:
  - move master spreadsheet to data/raw.  
  - move temporal data spreadhseet to data/raw
- Data cleaning is in R/data_prep_master.R, R/data_prep_temporal.R, and R/data_prep_size.R
  - need to update Readme with this.
- Cleaned output csv that is basis for all analysis is data/crab_data.csv
- burrows mp in jho correlations, and mp only in master have messed up burrow 
counts.  

# Correlations

- Given issues above with data, correlations re-done with master data
  - slight differences in original source data for anova vs corr
- Also, focus on signficance dropped and all correlations reported in figure.
- correlations are calculated in R/crab_calc_correlation.R
- correlation, p, and n are included in results/crab_correlations.csv
- Correlation figure calced in R/corr_fig.R
- I checked results in crab_correlations against what was reported in Table 4. 
All check out, except burrow_density, shear_strength, mp. 
  - burrow counts messed up for burrow density in mp in the jho correlation data 
  and in the master mp only tab.  Looks good in master data and in R version of 
  master data.  Value recorded in Table 4 is incorrect.  It is not 0.49, should 
  be -0.088.
- Need to work on figure:  Color scheme, sizes aren't cutting it.
- Should probably also filter out what gets plotted based on sample size.  

# Anova

- Keep main anovas
  - was able to reproduce Table 2. with exception of carcinus.  Slight 
  diferences in the F statistic.  Got this with master spreadsheet as source and
  also with anova spreadsheet as source.  Need to update values in Table 2.
- Drop multiple comparisons and Table 3
  - small sample size for each comparison (only 10) and within habitats are 
  pseudo-replicates.
  - Not sure what it tells us
  - yep, lots of differences between/within marsh and habitats, but I don't find 
  that very interesting.  The big picture diff's are more interesting.
- anovas re-run in R/anovas.R
- anova results output in results/anova_results.csv

# Temporal

- Temporal data was reorganized by hand and is in sheet 2 in 
data/raw/jho_temporal_data_summarized.xls
- Data read in an prepped in R/data_prep_temporal.R
- Temporal figures built in R/temporal_fig.R
- I would like to drop the water temperature plot.  It is flat, currently on a
plot with two y-axis, and doesn't add much to the story (IMO).

# Crab size distribution

- Raw data in data/raw/species size histograms.xls and brrow data for histrograms.xls
- data read in and prepped in R/data_prep_size.R
- Size distribution figure in R/size_fig.R
- 

# Functions