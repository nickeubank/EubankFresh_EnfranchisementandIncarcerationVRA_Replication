***********************
* Set these globals before running
***********************


global NewJimCrow "/users/nick/github/EubankFresh_EnfranchisementandIncarcerationVRA/"
global rscript "/usr/local/bin/rscript"

**************
* What follows you should not have to modify
**************

clear

global closef = "capture file close myfile"
global openf = "file open myfile using"
global writef = "file write myfile"

cd $NewJimCrow


* create state analysis variables
*--------------------------

// 	// create analysis variables
//  	do $NewJimCrow/10_code/30_st_create_analysis_vars/10_add_st_analysis_vars.do
//  	do $NewJimCrow/10_code/30_st_create_analysis_vars/15_create_st_sample_restriction.do

// 	* Call Amelia MI from stata
// 	cd $NewJimCrow/10_code/30_st_create_analysis_vars/
// 	!$rscript 17_st_amelia_multipleimputations.R

// 	cd $NewJimCrow
// 	do $NewJimCrow/10_code/30_st_create_analysis_vars/20_restricted_st_sample_summarystats.do

 * create county analysis variables
 *--------------------------

//  	// create analysis variables
//  	do $NewJimCrow/10_code/40_cty_create_analysis_vars/10_cty_add_imputations.do
//  	do $NewJimCrow/10_code/40_cty_create_analysis_vars/20_add_cty_analysis_vars.do
//     do $NewJimCrow/10_code/40_cty_create_analysis_vars/25_create_analysis_sample.do

// 	* Call Amelia MI from stata
//     cd $NewJimCrow/10_code/40_cty_create_analysis_vars/
//     !$rscript 30_cty_amelia_multipleimputations.R
// 	cd $NewJimCrow

* run the analysis
*-----------------

	// run the analysis
// 	do $NewJimCrow/10_code/50_analysis/20_paper_output_state_sample_plots.do
// 	do $NewJimCrow/10_code/50_analysis/22_plot_each_state_raw_incar.do
// 	do $NewJimCrow/10_code/50_analysis/25_state_sample_MI_summarystats.do
// 	do $NewJimCrow/10_code/50_analysis/26_paper_output_state_sample_MI_ols.do
// 	do $NewJimCrow/10_code/50_analysis/27_paper_output_state_sample_MI_regs_fgls.do
// 	do $NewJimCrow/10_code/50_analysis/28_state_sample_MI_regs_ols_jackknife.do
	do $NewJimCrow/10_code/50_analysis/31_cty_main_effects_MI_ols.do
	do $NewJimCrow/10_code/50_analysis/41_cty_heterogeneous_effects_MI_ols.do
	do $NewJimCrow/10_code/50_analysis/44_cty_heterogeneous_effects_by_beo_MI_ols.do
// 	do $NewJimCrow/10_code/50_analysis/45_national_trends.do
// 	do $NewJimCrow/10_code/50_analysis/55_individual_numbers.do
// 	do $NewJimCrow/10_code/50_analysis/60_gallup_analysis.do
// 	do $NewJimCrow/10_code/50_analysis/61_attitudes_analysis_1969violence.do
// 	do $NewJimCrow/10_code/50_analysis/62_attitudes_analysis_anes.do
// 	do $NewJimCrow/10_code/50_analysis/63_attitudes_analysis_almondverba.do
// 	do $NewJimCrow/10_code/50_analysis/65_arrests.do
// 	do $NewJimCrow/10_code/50_analysis/70_beo.do
// 	do $NewJimCrow/10_code/50_analysis/80_paper_output_state_sample_MI_OLS_fisherexact.do
//     do $NewJimCrow/10_code/50_analysis/90_fisher_analysis_ols.do
//     do $NewJimCrow/10_code/50_analysis/100_eventstudy_MI_ols.do

//     cd $NewJimCrow/10_code/50_analysis/
//     !$rscript 110_drop_maximally_influential.R
// 	cd $NewJimCrow
