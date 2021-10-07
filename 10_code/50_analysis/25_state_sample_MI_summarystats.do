
	******************************************************************
	**
	**
	**		NAME:	ADRIANE FRESH and NICK EUBANK
	**		DATE: 	February 20, 2020
	**
	**		PROJECT: 	New Jim Crow
	**		DETAILS: 	This file creates output tables and figures for
	**					the paper presented at USC March 2020.
	**
	**
	**		UPDATE(S):
	**
	**
	**		SOFTWARE:	Stata Version 16.0
	**
	******************************************************************







				** ALL SAMPLE RESTRICTED ANALYSIS **







			**	**	**	**	**	**	**	**	**	**	**	**	**
			**	**	**	**	**	**	**	**	**	**	**	**	**
			**	**	**	**	**	**	**	**	**	**	**	**	**



*-------------------------------------------------------------------------------
* preliminaries
*-------------------------------------------------------------------------------


* clear
*------

clear



* more
*-----

set more off, perm




			**	**	**	**	**	**	**	**	**	**	**	**	**
			**	**	**	**	**	**	**	**	**	**	**	**	**
			**	**	**	**	**	**	**	**	**	**	**	**	**

						 ** STATE TABLES **

			**	**	**	**	**	**	**	**	**	**	**	**	**
			**	**	**	**	**	**	**	**	**	**	**	**	**
			**	**	**	**	**	**	**	**	**	**	**	**	**






			**	**	**	**	**	**	**	**	**	**	**	**	**
			**	**	**	**	**	**	**	**	**	**	**	**	**
			**	**	**	**	**	**	**	**	**	**	**	**	**


*-------------------------------------------------------------------------------
* STATEWIDE TABLE: linear  with controls
*-------------------------------------------------------------------------------



* globals
*--------

global dv1 			= "st_icpsr_MI_rate_black"
global dv2 			= "st_icpsr_MI_rate_bminusw"

global nonpar		= "vra2_x_post1965"
global linear		= "vra2_x_post1965 vra2_x_year post1965_x_year vra2_x_post1965_x_year year post_1965"

global controls 	= "st_census_urban_perc"
global cluster		= "state"

* regressions
*------------
clear

cd $NewJimCrow/20_intermediate_data/40_analysis_datasets/15_state_analysis_data_main_with_mi

foreach i in black bminusw {

        forvalues d = 1/5 {
            use njc_MI`d', clear
            bysort state: egen temp_mean = mean(st_icpsr_MI_rate_`i')
            gen demeaned_`i' = st_icpsr_MI_rate_`i' - temp_mean

            gen within_state_sd_`i' = .
            levelsof state, local(states)
            foreach s of local states {
                display "`s'"
                egen temp = sd(demeaned_`i') if state == "`s'"
                tab temp
                replace within_state_sd_`i' = temp if state == "`s'"
                drop temp
            }
            save njcdm`d', replace
        }

        misum njcdm st_icpsr_MI_rate_`i'
        local cleaned_mean: display %12.1fc `r(mean)'

        misum njcdm within_state_sd_`i'
        local cleaned_std: display %12.1fc `r(mean)'

        ${closef}
        ${openf} "$NewJimCrow/50_results/states_mean_`i'.tex", write replace
        ${writef} "`cleaned_mean'"
        ${closef}

        ${closef}
        ${openf} "$NewJimCrow/50_results/states_std_`i'.tex", write replace
        ${writef} "`cleaned_std'"
        ${closef}


}

			**	**	**	**	**	**	**	**	**	**	**	**	**
			**	**	**	**	**	**	**	**	**	**	**	**	**
			**	**	**	**	**	**	**	**	**	**	**	**	**


					   ** end of do file **
