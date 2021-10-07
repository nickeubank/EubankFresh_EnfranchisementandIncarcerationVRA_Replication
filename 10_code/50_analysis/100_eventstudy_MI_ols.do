
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

global controls 	= "st_census_urban_perc"
global cluster		= "state"

* regressions
*------------
discard
clear
*set more off
*set trace on


cd $NewJimCrow/20_intermediate_data/40_analysis_datasets/15_state_analysis_data_main_with_mi

_eststo clear
local model_num = 1
forvalues x = 1/2 {

    ***********************
    *
    * non-parametric full
    *
    ***********************

    forvalues i = 1/5 {
        use njc_MI`i', clear

        * Get back plain VRA
        bysort state: egen vra = max(vra2_x_post1965)
        tab state vra

        forvalues z = 0/4 {
            local lower = `z' * 5 + 1955
            local upper = (`z' + 1) * 5 + 1955
            display "from `lower' to `upper'"
            gen vra_x_`lower'_`upper' = 0
            replace vra_x_`lower'_`upper' = 1 if `lower' < year & year <= `upper' & vra ==1
        }
        replace vra_x_1975_1980 = 1 if year >= 1980 & vra == 1
        rename vra_x_1975_1980 vra_x_1975_1982

        save njcMIw`i', replace
    }

    local est = "est_`model_num'"
    local model_num = `model_num' + 1

    eststo `est':	miest njcMIw reg  ${dv`x'} ${controls} vra_x_* year_* state_* ///
                        , cluster($cluster)

                        estadd local statefixed "\checkmark": `est'
                        estadd local yearfixed "\checkmark": `est'
                        estadd local N2 "`e(N)'": `est'

                        use njc_MI1, clear

                        distinct state if ${dv`x'} != .
                        estadd scalar clusters = `r(ndistinct)': `est'

                        clear

}

	* output the regressions
	*-----------------------

    * Load data and label for esttab
    use njc_MI1, clear

    bysort state: egen vra = max(vra2_x_post1965)
    tab state vra

    forvalues z = 0/4 {
        local lower = `z' * 5 + 1955
        local upper = (`z' + 1) * 5 + 1955
        display "from `lower' to `upper'"
        gen vra_x_`lower'_`upper' = 0
        label var vra_x_`lower'_`upper' "Sec 5 x `lower'-`upper'"
    }
    replace vra_x_1975_1980 = 1 if year >= 1980 & vra == 1
    rename vra_x_1975_1980 vra_x_1975_1982
    label var vra_x_1975_1982 "Sec 5 x 1975-1982"


    label var st_census_pop_total_ln		"ln(pop)"
    label var st_census_urban_perc			"Pop urban (\%)"

	#delimit;

	esttab
        est_1
        est_2
		using $NewJimCrow/50_results/event_study_MI_OLS.tex,
			b(a2) label replace nogaps compress se(a2) bookt
			noconstant nodepvars star(* 0.1 ** 0.05 *** 0.01)
			fragment  substitute(\_ _)
            drop(state_* _cons year_* st_census_urban_perc)


			stats(
                        N2
                        statefixed
						yearfixed
                        clusters
						,

				labels("No. Obs"
                        "State FE"
						"Year FE"
                        "Clusters"
						)
					)
			title("")
			nomtitles
		;

	#delimit cr
    clear

			**	**	**	**	**	**	**	**	**	**	**	**	**
			**	**	**	**	**	**	**	**	**	**	**	**	**
			**	**	**	**	**	**	**	**	**	**	**	**	**


					   ** end of do file **
