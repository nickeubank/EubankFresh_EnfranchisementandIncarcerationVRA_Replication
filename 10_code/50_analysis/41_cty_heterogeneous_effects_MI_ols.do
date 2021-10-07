clear
set more off, perm

* read in state-level data (SAMPLE RESTRICTED)
*---------------------------------------------
cd 		$NewJimCrow
use   	20_intermediate_data/40_analysis_datasets/30_county_analysis_sample.dta , clear



* globals
*--------

global dv1 			= "cty_hc_MI_rate_black"
global dv2 			= "cty_hc_MI_rate_bminusw"

global controls		= "census_urban_perc"
global nonpar		= "vra2_x_post1965"

global cluster		= "state_county_fips"

assert census_pop_black >= 100

local subsample_count = 4
// set more off
// set trace on

cd $NewJimCrow/20_intermediate_data/40_analysis_datasets/30_cty_analysis_data_with_MI

foreach drops in threestates allstates {

    foreach measure in   first_census_pop_black_perc   first_vreg_share_black   {
        foreach dv_num in 1 2  {
            local est_counter = 1
            forvalues sample = 1/`subsample_count' {

                * Define splits and labels vars
                if "`measure'" == "first_census_pop_black_perc" {
                    local interval = 0.15
                    local start = 0.05
                }
                else {
                    local interval = 0.1
                    local start = 0
                }
                local lower = (`sample' - 1) * `interval' + `start'
                local upper = `sample' * `interval' + `start'
                local lower_str: display `lower'*100 %2.0f
                local upper_str: display `upper'*100 %2.0f

                * Define condition
                local subsample = "`lower' <= `measure' & `measure' < `upper'"
                if `sample' == `subsample_count' {
                    local subsample = "`lower' <= `measure' & `measure' != ."
                }

                ***********
                *
                * Run Regression
                *
                ***********

                * First, FGLS weights
                forvalues i = 1/5 {


                    use ctyMI`i', clear
                    keep if year <= 1965 | year >= 1975
                    if "`drops'" == "threestates" {
                        keep if state == "Tennessee" | state == "Georgia" | state == "Alabama"
                    }
                    drop if first_census_pop_black_perc < 0.05
                    display "`i'"
                    save ctyMIw`i', replace
                }

                local est = "est_`est_counter'"
                local est_counter = `est_counter' + 1

                eststo `est': miest ctyMIw reg ${dv`dv_num'} ${nonpar}  ${controls} year_* countyfe_* ///
                                if `subsample' ///
                                , cluster($cluster)

    			estadd local 	countyfixed "\checkmark": `est'
    			estadd local 	controls "\checkmark": `est'
                estadd local 	yearfixed "\checkmark": `est'
                estadd local    size "`e(N)'": `est'

                use ctyMIw1, clear
                sum year, d
                local start = `r(min)' - 1900
                local end = `r(max)' - 1900
                estadd local period "`start'-65, 75-`end'": `est'

                distinct state if ${dv`dv_num'} != .
                estadd scalar states = `r(ndistinct)': `est'



                ***********
                *
                * End Regression
                *
                ***********

                local title`sample' = "`lower_str'\%-`upper_str'\%"
                if `sample' == `subsample_count' {
                    local title`sample' = "$>$ `lower_str'\%"
                }

            }

            * Define labels
            if "`measure'" == "first_census_pop_black_perc" {
                local measure_label = "pop"
            }
            if "`measure'" == "first_vreg_share_black" {
                local measure_label = "reg"
            }
            if "${dv`dv_num'}" == "cty_hc_MI_rate_black" {
                local rate = "black"
            }
            if "${dv`dv_num'}" == "cty_hc_MI_rate_bminusw" {
                local rate = "bminusw"
            }

            use ctyMI1, clear
            label var vra2_x_post1965 "VRA $\times$ Post-1965"

        	esttab ///
        		est_1 ///
        		est_2 ///
        		est_3 ///
        		est_4 ///
        		using "$NewJimCrow/50_results/heterogeneous_`measure_label'_`rate'_rate_ols_MI_`drops'.tex", ///
        			b(a2) label replace nogaps compress se(a2) bookt ///
        			noconstant nodepvars star(* 0.1 ** 0.05 *** 0.01) ///
        			fragment  substitute(\_ _) ///
                    keep(${nonpar}) ///
        			mtitles("`title1'" "`title2'" "`title3'" "`title4'" "`title5'") ///
        			stats(		countyfixed ///
        						yearfixed ///
        						controls ///
                                size ///
                                period ///
                                states ///
        						, ///
        				labels( "County FE" ///
        						"Year FE" ///
        						"Controls" ///
                                "Num Obs" ///
                                "Period" ///
                                "States" ///
        						) ///
        					)

        }
    }
}
