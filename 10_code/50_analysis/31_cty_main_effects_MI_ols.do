
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

set more off, perm

discard




		**	**	**	**	**	**	**	**	**	**	**	**	**
		**	**	**	**	**	**	**	**	**	**	**	**	**
		**	**	**	**	**	**	**	**	**	**	**	**	**


*-------------------------------------------------------------------------------
* read in data
*-------------------------------------------------------------------------------


* read in state-level data
*-------------------------

		// sample restricted

cd 		$NewJimCrow
use   	"20_intermediate_data/40_analysis_datasets/30_county_analysis_sample.dta" , clear



		**	**	**	**	**	**	**	**	**	**	**	**	**
		**	**	**	**	**	**	**	**	**	**	**	**	**
		**	**	**	**	**	**	**	**	**	**	**	**	**



*-------------------------------------------------------------------------------
* read in data
*-------------------------------------------------------------------------------


* globals
*--------

global dv1 			= "cty_hc_MI_rate_black"
global dv2 			= "cty_hc_MI_rate_bminusw"

global controls		= "census_urban_perc"
global nonpar		= "vra2_x_post1965"

global cluster		= "state_county_fips"

assert census_pop_black >= 100





*-------------------------------------------------------------------------------
* set directory
*-------------------------------------------------------------------------------


* cd
*---

cd $NewJimCrow/20_intermediate_data/40_analysis_datasets/30_cty_analysis_data_with_MI





		**	**	**	**	**	**	**	**	**	**	**	**	**
		**	**	**	**	**	**	**	**	**	**	**	**	**
		**	**	**	**	**	**	**	**	**	**	**	**	**



*-------------------------------------------------------------------------------
* REPRESENTATIVE SAMPLE
*-------------------------------------------------------------------------------

* clear
*------

clear




* loop
*-----

_eststo clear

local model_num = 1



forvalues x = 1/2 {


	* non-parametric part
	*--------------------
    local est = "est_`model_num'"
    local model_num = `model_num' + 1



	* plain vanilla part 1
	*---------------------
    forvalues i = 1/10 {

        use ctyMI`i', clear

			keep if state == "Tennessee" | state == "Georgia" | state == "Alabama"
			//drop if (county_name == "Collier" | county_name == "Hardee" | county_name == "Hendry" ///
						//| county_name == "Hillsborough" | county_name == "Monroe") & state == "Florida"
			drop if first_census_pop_black_perc < 0.05

        save ctyMIw`i', replace

    }




	* regression
	*-----------

    eststo `est':	miest ctyMIw reg ${dv`x'} ${nonpar} ${controls} year_* countyfe_* ///
                        , cluster($cluster)

						// sum ${dv`x'}
						// estadd scalar meandv = `r(mean)': `est'
						// capture drop sd
						// egen sd = sd(${dv`x'}_dm)
						// sum sd
                        // estadd scalar stddv = `r(mean)': `est'
                        // estadd scalar clusters = e(N_clust): `est'
                        // estadd scalar groups = e(N_g): `est'

                        estadd local statefixed "\checkmark": `est'
                        estadd local yearfixed "\checkmark": `est'
                        estadd local N2 "`e(N)'": `est'

                        use ctyMIw1, clear
                        sum year, d
                        estadd local period "`r(min)'-`r(max)'": `est'

                        distinct $cluster if ${dv`x'} != .
                        estadd scalar clusters = `r(ndistinct)': `est'

                        distinct state if ${dv`x'} != .
                        estadd scalar states = `r(ndistinct)': `est'


   * clear
   *------

   clear



						** ** ** **
						** ** ** **



    * long difference part
	*---------------------
    local est = "est_`model_num'"
    local model_num = `model_num' + 1



	* plain vanilla part 2
	*---------------------
    forvalues i = 1/10 {

        use ctyMI`i', clear

			keep if state == "Tennessee" | state == "Georgia" | state == "Alabama"
			//drop if (county_name == "Collier" | county_name == "Hardee" | county_name == "Hendry" ///
						//| county_name == "Hillsborough" | county_name == "Monroe") & state == "Florida"
            drop if first_census_pop_black_perc < 0.05


        save ctyMIw`i', replace

    }



	* regression
	*-----------
	eststo `est':	miest ctyMIw reg ${dv`x'} ${nonpar} ${controls} year_* countyfe_* ///
						if year <= 1965 | year >= 1975 , cluster($cluster)

						// sum ${dv`x'}
						// estadd scalar meandv = `r(mean)': `est'
						// capture drop sd
						// egen sd = sd(${dv`x'}_dm)
						// sum sd
						// estadd scalar stddv = `r(mean)': `est'
						// estadd scalar clusters = e(N_clust): `est'
						// estadd scalar groups = e(N_g): `est'

						estadd local statefixed "\checkmark": `est'
						estadd local yearfixed "\checkmark": `est'
                        estadd local N2 "`e(N)'": `est'

                        use ctyMIw1, clear
                        sum year, d
                        local start = `r(min)' - 1900
                        local end = `r(max)' - 1900
                        estadd local period "`start'-65, 75-`end'": `est'

                        distinct $cluster if ${dv`x'} != .
                        estadd scalar clusters = `r(ndistinct)': `est'

                        distinct state if ${dv`x'} != .
                        estadd scalar states = `r(ndistinct)': `est'

                        clear

}

	* output the regressions
	*-----------------------

		// load data and label for esttab

    use ctyMIw1, clear

    label var vra2_x_post1965 				"Post-1965 $\times$ Covered"



	cd $NewJimCrow/50_results



	#delimit;

	esttab

        est_1
        est_2
        est_3
        est_4

		using "table_cty_main_effect_MI_ols_representativesample.tex",
			b(a2) label replace nogaps compress se(a2) bookt
			noconstant nodepvars star(* 0.1 ** 0.05 *** 0.01)
			fragment  substitute(\_ _)
            drop(countyfe_* year_* _cons census_urban_perc )


			stats(        N2
                        statefixed
						yearfixed
                        period
                        clusters
                        states
						,

				labels("No. Obs"
                        "State FE"
						"Year FE"
                        "Sample Period"
                        "Clusters"
                        "States"
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



*-------------------------------------------------------------------------------
* ALL STATES
*-------------------------------------------------------------------------------

* clear
*------

clear

cd $NewJimCrow/20_intermediate_data/40_analysis_datasets/30_cty_analysis_data_with_MI



* loop
*-----

_eststo clear

local model_num = 1



forvalues x = 1/2 {


	* non-parametric part
	*--------------------
    local est = "est_`model_num'"
    local model_num = `model_num' + 1



	* plain vanilla part 1
	*---------------------
    forvalues i = 1/10 {

        use ctyMI`i', clear

			drop if first_census_pop_black_perc < 0.05

        save ctyMIw`i', replace

    }




	* regression
	*-----------

    eststo `est':	miest ctyMIw reg ${dv`x'} ${nonpar} ${controls} year_* countyfe_* ///
                        , cluster($cluster)

						// sum ${dv`x'}
						// estadd scalar meandv = `r(mean)': `est'
						// capture drop sd
						// egen sd = sd(${dv`x'}_dm)
						// sum sd
                        // estadd scalar stddv = `r(mean)': `est'
                        // estadd scalar clusters = e(N_clust): `est'
                        // estadd scalar groups = e(N_g): `est'

                        estadd local statefixed "\checkmark": `est'
                        estadd local yearfixed "\checkmark": `est'
                        estadd local N2 "`e(N)'": `est'

                        use ctyMIw1, clear
                        sum year, d
                        estadd local period "`r(min)'-`r(max)'": `est'

                        distinct $cluster if ${dv`x'} != .
                        estadd scalar clusters = `r(ndistinct)': `est'

                        distinct state if ${dv`x'} != .
                        estadd scalar states = `r(ndistinct)': `est'

   * clear
   *------

   clear



						** ** ** **
						** ** ** **



    * long difference part
	*---------------------
    local est = "est_`model_num'"
    local model_num = `model_num' + 1



	* plain vanilla part 2
	*---------------------
    forvalues i = 1/10 {

        use ctyMI`i', clear

            drop if first_census_pop_black_perc < 0.05

        save ctyMIw`i', replace

    }



	* regression
	*-----------
	eststo `est':	miest ctyMIw reg ${dv`x'} ${nonpar} ${controls} year_* countyfe_* ///
						if year <= 1965 | year >= 1975 , cluster($cluster)

						estadd local statefixed "\checkmark": `est'
						estadd local yearfixed "\checkmark": `est'
                        estadd local N2 "`e(N)'": `est'



                        use ctyMIw1, clear
                        sum year, d
                        local start = `r(min)' - 1900
                        local end = `r(max)' - 1900
                        estadd local period "`start'-65, 75-`end'": `est'

                        distinct $cluster if ${dv`x'} != .
                        estadd scalar clusters = `r(ndistinct)': `est'

                        distinct state if ${dv`x'} != .
                        estadd scalar states = `r(ndistinct)': `est'

                        clear

}

	* output the regressions
	*-----------------------

		// load data and label for esttab

    use ctyMIw1, clear

    label var vra2_x_post1965 				"Post-1965 $\times$ Covered"



	cd $NewJimCrow/50_results



	#delimit;

	esttab

        est_1
        est_2
        est_3
        est_4

		using "table_cty_main_effect_MI_ols_allstates.tex",
			b(a2) label replace nogaps compress se(a2) bookt
			noconstant nodepvars star(* 0.1 ** 0.05 *** 0.01)
			fragment  substitute(\_ _)
            drop(countyfe_* year_* _cons census_urban_perc)


			stats(        N2
                        statefixed
						yearfixed
                        period
                        clusters
                        states
						,

				labels("No. Obs"
                        "State FE"
						"Year FE"
                        "Sample Period"
                        "Clusters"
                        "States"
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
