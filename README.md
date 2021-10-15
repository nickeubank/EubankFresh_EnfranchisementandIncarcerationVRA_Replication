# Replication Package for Eubank & Fresh (2021)


This repository contains data and code for replicating the analysis in Eubank and Fresh (2021)'s Enfranchisement and Incarceration After the 1965 Voting Rights Act.

The code requires Stata/MP 16.1 and R 4.1.0.

(I'm sorry -- if this were all R & Python, I'd just make you a docker image, but don't know how to do that with Stata given licensing issues.)

## To run the replication package: 

1. install the relevant third party scripts (see "Required Packages" below), 
2. open `master_dofile.do` and set the two globals at the top of the file (`NewJimCrow` and `rscript`). 
   - `NewJimCrow` should be the location of the replication package (e.g. this folder), and `rscript` should be the location on your system where the `rscript` function for running R scripts can be found (NewJimCrow was our colloquial name for the project when it began). On a mac, you can find this path with the command `which rscript`, and for me it is in `/usr/local/bin/rscript`. 
3. Run the `master_dofile.do` file. All results should appear in the `50_results` folder.
4. Build the manuscript `30_docs/manuscript/EubankFresh_Incarceration.tex`. All new results will be pulled into the document dynamically.

Note that if you struggle getting Stata to run the R code directly, you can run the three R scripts required for replication (`10_code/30_st_create_analysis_vars/17_st_amelia_multipleimputations.R`, `10_code/40_cty_create_analysis_vars/30_cty_amelia_multipleimputations.R`, and `10_code/50_analysis/90_drop_maximally_influential.R`) by hand at the appropriate times.

Also note that if there are problems with those R files, Stata won't stop the execution of `master_dofile.do`, it will just move on, so if you have problems, make sure those files ran correctly. 

Replication can be re-re-run (not a typo) by deleting everything in 50_results, and all FILES in `20_intermediate_data/40_analysis_datasets` and `20_intermediate_data/50_saved_estimates` (note you have to keep the folders, as the code will try and put things into those folders).

## A Note On Random Seeds

We have set random seeds for the multiple imputations (which is stochastic). HOWEVER: I have, in all my years doing replications, never been able to get random seeds in R to be really stable across operating systems, installations, etc. So... odds are you'll get results that differ slightly from those in our paper. Sorry. Suggestions on creating more stable random seeds in R welcome!

## File Names

If you're wondering about the numeric prefixes to files and folders, they are ordinal but not cardinal -- new files are initially created at intervals of ten (e.g. 10_firstfile.do, 20_secondfile.do, etc.) so one can easily later add files between existing files (e.g. 15_oh_need_another_here.do), preserving the ordinal information about how files should be run without requiring all files be renamed.

## Required packages

### miest

For properly calculating standard errors after multiple imputation, we use the `miest` package from Ken Scheve. HOWEVER we did have to modify it a little to update for Stata 16 (side note: if you're here to learn multiple imputation, just use the Stata inbuilt tools. We didn't realize it has them, but... it does. At least in recent versions). 

So please place the files miest.ado, miest.hlp, misum.ado, and misum.hlp located in the `PACKAGES_miest` folder in your PERSONAL ado directory (run `sysdir` to find).

### ssc installable packages 

For stata, please install from ssc:

[1] package dm88_1 from http://www.stata-journal.com/software/sj5-4
      SJ5-4 dm88_1.  Update:  Renaming variables, multiply and...

[2] package zipsave from http://fmwww.bc.edu/RePEc/bocode/z
      'ZIPSAVE': module to save and use datasets compressed by zip

[3] package st0085_2 from http://www.stata-journal.com/software/sj14-2
      SJ14-2 st0085_2. Update: Making regression...

[4] package corrtex from http://fmwww.bc.edu/repec/bocode/c
      'CORRTEX': module to generate correlation tables formatted in LaTeX

[5] package carryforward from http://fmwww.bc.edu/repec/bocode/c
      'CARRYFORWARD': module to carry forward previous observations

[6] package st0278 from http://www.stata-journal.com/software/sj12-4
      SJ12-4 st0278. Robinson's square root of N consistent ...

[7] package tabout from http://fmwww.bc.edu/repec/bocode/t
      'TABOUT': module to export publication quality cross-tabulations

[8] package texsave from http://fmwww.bc.edu/repec/bocode/t
      'TEXSAVE': module to save a dataset in LaTeX format

[9] package dm0042_2 from http://www.stata-journal.com/software/sj15-3
      SJ15-3 dm0042_2. Update: Report number(s) of...


### R Packages

For multiple imputation, we use only Amelia (`Amelia_1.8.0`) and haven (`haven_2.4.3`), though haven is just for loading stata datasets, so I'm sure any version of Stata is fine. 

For testing robustness by dropping maximally influential observations (`10_code/50_analysis/90_drop_maximally_influential.R`) we use also use:

- `Zelig_5.1.7`
- `devtools_2.4.2`
- `sandwich_3.0-1`
- `xtable_1.8-4`

(and their associated dependencies), along with the [zaminfluence package](https://github.com/rgiordan/zaminfluence). The zaminfluence package installation directions in October 2021 are:

```r
library(devtools)
devtools::install_github("https://github.com/rgiordan/zaminfluence/",
                           ref="master",
                           subdir="zaminfluence",
                           force=TRUE)
```

Note that at the time we are writing this replication package, the package is at commit dc2dac4928b4c760e6e8f14b19ddea38f0504e56 . 
