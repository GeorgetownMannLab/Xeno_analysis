# Xeno_analysis

This repository contains the data and code which produce Figure 4, Figure 5, Table 1, and Table 2 from the manuscript "Some like it hot: Temperature and hydrodynamic factors influence Xenobalanus globicipitis attachment to cetaceans"

## Directories and Content
* **AnalysisCode** contains code that is used for modeling analysis and figure production
	+ `01_KeyConstruction.R` produces `key.RData`, an intermediate product and input file of `05_HydroTempModel.R`
	+ `02_maketpoints.R` produces *tpoints.Rdata*, an intermediate product and input file of `05_HydroTempModel.R`
	+ `03_figure4.R` produces Figure 4, a plot of *X.globicipitis* attachment on a thermal image of a dorsal fin
	+ `04_geotemp.R` runs a logistic regression on presence/absence of *X.globicipitis* and max sea surface temperature, produces Figure 5 and corresponding logistic model statistics in Table 2
	+ `05_HydroTempModel.R` runs a poisson model on temperature and hydrodynamic location, produces corresponding poisson model statistics in Table 2 **Note: this code can only function after the codes *make_tpoints.R* and *KeyConstruction.R*** 
	
* **RawData** contains the necessary input data for the analysis code
	+ `Geo_data_11_15.csv` geographic *X.globicipitis* presence/absence data, input for `04_geotemp.R` 
	+ `Xeno_pts_v2.csv` coordinates of *X.globicipitis* attachment points to the dorsal fin, input of `02_maketpoints.R`
	+ `newSfb218-75.tif` thermal image of a dorsal fin from Meagher et al. (2002), input of `figure_4.R`
	+ `no_background.tiff` thermal image with background manually removed, input of `05_HydroTempModel.R`
	
* **IntermediateData** contains data that is produced by one code and input for another
	+ `key.RData` cell-color to temperature translation, input for `05_HydroTempModel.R`, produced by `01_KeyConstruction.R`
	+ `tpoints.RData` affine-transformed *X.globicipitis* attachments, input for `05_HydroTempModel.R`, produced by `02_maketpoints.R`

* **TablesFigures** contains outputs of **AnalysisCode** included in the manuscript
	+ `Figure_4.pdf` thermal image with *X.globicipitis* attachments
	+ `Figure_5.pdf` logistic regression of *X.globicipitis* presence/absence and max sea surface temperature by species
	+ `logistic_summary.csv` *Table 2* in the the manuscript, statistics for geographic logistic regression
	+ `poisson_summary.csv` *Table 1* in the manuscript, statistics for the spatial poisson model
	

