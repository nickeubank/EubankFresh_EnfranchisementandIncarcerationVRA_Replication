


		**	**	**	**	**	**	**	**	**	**	**	**	**
		**	**	**	**	**	**	**	**	**	**	**	**	**
		**	**	**	**	**	**	**	**	**	**	**	**	**


					** BEO HETEROGENEITY **


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
* read in data to look at
*-------------------------------------------------------------------------------

	// this is the data that is going to merge with the MI files


* read in county-level data
*--------------------------

		// sample restricted

cd 		$NewJimCrow
use   	"20_intermediate_data/40_analysis_datasets/30_county_analysis_sample.dta" , clear



		**	**	**	**	**	**	**	**	**	**	**	**	**
		**	**	**	**	**	**	**	**	**	**	**	**	**
		**	**	**	**	**	**	**	**	**	**	**	**	**



*-------------------------------------------------------------------------------
* globals for MI analysis
*-------------------------------------------------------------------------------


* globals
*--------


global dv1 			= "cty_hc_MI_rate_black"
global dv2 			= "cty_hc_MI_rate_bminusw"

global controls		= "census_urban_perc"
//global nonpar		= "vra2_x_post_x_beo_local  beo_any_local"
global nonpar		= "vra2_x_post_x_beoanyL1_local   vra2_x_post1965 beo_any_local_L1"  //     vra2_x_post1965  vra2_x_post_x_beol3_local

global cluster		= "state_county_fips"

assert census_pop_black >= 100





*-------------------------------------------------------------------------------
* set directory for MI analysis
*-------------------------------------------------------------------------------


* cd
*---

cd $NewJimCrow/20_intermediate_data/40_analysis_datasets/30_cty_analysis_data_with_MI





		**	**	**	**	**	**	**	**	**	**	**	**	**
		**	**	**	**	**	**	**	**	**	**	**	**	**
		**	**	**	**	**	**	**	**	**	**	**	**	**



*-------------------------------------------------------------------------------
* loop
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

		cd $NewJimCrow/20_intermediate_data/40_analysis_datasets/30_cty_analysis_data_with_MI
        use ctyMI`i', clear

			keep if state == "Tennessee" | state == "Georgia" | state == "Alabama"
			drop if first_census_pop_black_perc < 0.05


		cd $NewJimCrow/20_intermediate_data/40_analysis_datasets/
		merge 1:1 state_county_fips year using "30_county_analysis_sample.dta"

		tab _merge
		drop if _merge == 2
		drop _merge

			capture label var vra2_x_post_x_beo_local 	"Post-1965 $\times$ Covered $\times$ BEO"
			capture label var beo_any_local 			"BEO"
			capture label var vra2_x_post1965			"Post-1965 $\times$ Covered"

        if `i' == 1 {
            sum beo_any_local_L1
            local cleaned_mean: display %12.1fc `r(mean)'*100

            ${closef}
            ${openf} "$NewJimCrow/50_results/beo_share_with_any.tex", write replace
            ${writef} "`cleaned_mean'"
            ${closef}
        }
		cd $NewJimCrow/20_intermediate_data/40_analysis_datasets/30_cty_analysis_data_with_MI
        save ctyMIw`i', replace

    }




	* regression 1
	*-------------

    eststo `est':	miest ctyMIw reg ${dv`x'} ${nonpar} ${controls} year_* countyfe_* ///
                        , cluster($cluster)

                        estadd local statefixed "\checkmark": `est'
                        estadd local yearfixed "\checkmark": `est'
                        estadd local N2 "`e(N)'": `est'

                        use ctyMIw1, clear
                        sum year, d
                        estadd local period "`r(min)'-`r(max)'": `est'

                        distinct state if ${dv`x'} != .
                        estadd scalar clusters = `r(ndistinct)': `est'


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

		cd $NewJimCrow/20_intermediate_data/40_analysis_datasets/30_cty_analysis_data_with_MI
        use ctyMI`i', clear

			keep if state == "Tennessee" | state == "Georgia" | state == "Alabama"
            drop if first_census_pop_black_perc < 0.05


		cd $NewJimCrow/20_intermediate_data/40_analysis_datasets
		merge 1:1 state_county_fips year using "30_county_analysis_sample.dta"

		tab _merge
		drop if _merge == 2
		drop _merge

		    capture label var vra2_x_post_x_beo_local 	"Post-1965 $\times$ Covered $\times$ BEO"
			capture label var beo_any_local 			"BEO"
			capture label var vra2_x_post1965			"Post-1965 $\times$ Covered"


		cd $NewJimCrow/20_intermediate_data/40_analysis_datasets/30_cty_analysis_data_with_MI
        save ctyMIw`i', replace

    }



	* regression 2
	*-------------

	eststo `est':	miest ctyMIw reg ${dv`x'} ${nonpar} ${controls} year_* countyfe_* ///
						if year <= 1965 | year >= 1975 , cluster($cluster)

						estadd local statefixed "\checkmark": `est'
						estadd local yearfixed "\checkmark": `est'
                        estadd local N2 "`e(N)'": `est'

                        use ctyMIw1, clear
                        sum year, d
                        local start = `r(min)'
                        local end = `r(max)' - 1900
                        estadd local period "`start'-65, 1975-`end'": `est'

                        distinct state if ${dv`x'} != .
                        estadd scalar clusters = `r(ndistinct)': `est'

                        clear

}

	* output the regressions
	*-----------------------

		// load data and label for esttab

	//cd $NewJimCrow/20_intermediate_data/40_analysis_datasets/30_cty_analysis_data_with_MI
    //use ctyMIw1, clear

	cd 		$NewJimCrow
	use   	"20_intermediate_data/40_analysis_datasets/30_county_analysis_sample.dta" , clear


		// label variables

    capture label var vra2_x_post_x_beo_local 	"Post-1965 $\times$ Covered $\times$ BEO"
	capture label var beo_any_local_L3 		"BEO (\emph{t-}3)"
	capture label var beo_any_local_L2 		"BEO (\emph{t-}2)"
	capture label var beo_any_local_L1			"BEO (\emph{t-}1)"
	capture label var beo_any_local			"BEO"
	capture label var vra2_x_post1965			"Post-1965 $\times$ Covered"
	capture label var vra2_x_post_x_beoanyL3_local "Post-1965 $\times$ Covered $\times$ BEO (\emph{t-}3)"
	capture label var vra2_x_post_x_beoanyL2_local "Post-1965 $\times$ Covered $\times$ BEO (\emph{t-}2)"
	capture label var vra2_x_post_x_beoanyL1_local "Post-1965 $\times$ Covered $\times$ BEO (\emph{t-}1)"
		// results directory

	cd $NewJimCrow/50_results/



	#delimit;

	esttab

        est_1
        est_2
        est_3
        est_4

		using "table_cty_threefold_beo_MI_ols.tex",
			b(a2) label replace nogaps compress se(a2) bookt
			noconstant nodepvars star(* 0.1 ** 0.05 *** 0.01)
			fragment  substitute(\_ _)

            drop(countyfe_* year_* _cons  census*)


			stats(
                        N2
                        statefixed
						yearfixed
                        period
                        clusters
						,

				labels(
                        "No. Obs"
                        "State FE"
						"Year FE"
                        "Sample Period"
                        "States"
						)
					)
			title("")
			nomtitles
		;

	#delimit cr










			**	**	**	**	**	**	**	**	**	**	**	**	**
			**	**	**	**	**	**	**	**	**	**	**	**	**
			**	**	**	**	**	**	**	**	**	**	**	**	**


					   ** end of do file **
