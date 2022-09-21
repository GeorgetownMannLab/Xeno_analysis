# Xeno_analysis

This repository contains the data and code that produce the Figures 4 and 5 and the accompanying model-statistic in Tables 1 and 2 of the manuscript "Some like it hot: Temperature and hydrodynamic factors influence Xenobalanus globicipitis attachment to cetaceans"

## Directories and Content
* **AnalysisCode** contains code that is used for modeling analysis and figure production
	+ *KeyConstruction.R* produces *key.RData*, an intermediate product of cell-color to temperature translation and input file of *hydro_temp_model.R*
	+ *figure_4.R* produces Figure 4, a plot of *X.globicipitis* attachment on a thermal image of a dorsal fin
	+ *geo_temp.R* runs a logistic regression on presence/absence of *X.globicipitis* and max sea surface temperature, produces Figure 5 and corresponding logistic model statistics in Table 2
	+ *hydro_temp_model.R* runs a poisson model on temperature and hydrodynamic location, produces corresponding poisson model statistics in Table 2 **Note: this code must be performed after *make_tpoints.R* and *KeyConstruction.R***
	+ *make_tpoints.R* produces *tpoints.Rdata*, an intermediate product of affine-transformed *X.globicipitis* attachments and input file of *hydro_temp_model.R*

**RawData** contains the necessary input data for the analysis code

**IntermediateData** contains data that is produced by one code and input for another

