
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

sort state county examiners
replace examiners = examiners[_n-1] if examiners[_n] == . & examiners[_n-1] != . & county[_n] == county[_n-1]

bysort state examiners year: egen cty_hc_rate_black_m = mean(cty_hc_rate_black)
bysort state examiners year: egen cty_hc_rate_bminusw_m = mean(cty_hc_rate_bminusw)

sort state county year
egen tag_examyr = tag(state examiners year)


sort state county year
drop if county == "Screven"
# delimit ;


twoway 	(scatter cty_hc_rate_bminusw_m year if tag_examyr == 1 & examiners == 1 & state == "Alabama", mcolor(black))
		(scatter cty_hc_rate_bminusw_m year if tag_examyr == 1 & examiners == 0 & state == "Alabama", mcolor(gs7) msymbol(Oh) xline(1965) )

		(line cty_hc_rate_bminusw_m year if tag_examyr == 1 & examiners == 1  & state == "Alabama"  & year <= 1965, c(L) lcolor(black))
		(line cty_hc_rate_bminusw_m year if tag_examyr == 1 & examiners == 0  & state == "Alabama"  & year <= 1965, c(L) lcolor(gs7))

		(line cty_hc_rate_bminusw_m year if tag_examyr == 1 & examiners == 1  & state == "Alabama"  & year > 1965, c(L) lcolor(black))
		(line cty_hc_rate_bminusw_m year if tag_examyr == 1 & examiners == 0  & state == "Alabama"  & year > 1965, c(L) lcolor(gs7))

		, legend(off)
;

# delimit cr


// twoway (lpolyci cty_hc_rate_black_m year if tag_examyr == 1 & examiners == 1  & state == "Georgia"  & year <= 1965, clcolor(black) fcolor(none) bwidth(3) acolor(gs11))
// 		(lpolyci cty_hc_rate_black_m year if tag_examyr == 1 & examiners == 0  & state == "Georgia"  & year <= 1965, clcolor(gs7) fcolor(none) bwidth(3) acolor(gs11))
//
//
// 		(lpolyci cty_hc_rate_black_m year if tag_examyr == 1 & state == "Georgia"  & year > 1965, clcolor(black))
// 		(lpolyci cty_hc_rate_black_m year if tag_examyr == 0 & state == "Georgia"  & year > 1965, clcolor(gs7))


			**	**	**	**	**	**	**	**	**	**	**	**	**
			**	**	**	**	**	**	**	**	**	**	**	**	**
			**	**	**	**	**	**	**	**	**	**	**	**	**



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
global nonpar		= "examiner_x_post1965"

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
    forvalues i = 1/5 {

        use ctyMI`i', clear

			keep if  state == "Georgia" | state == "Alabama"
			//drop if (county_name == "Collier" | county_name == "Hardee" | county_name == "Hendry" ///
						//| county_name == "Hillsborough" | county_name == "Monroe") & state == "Florida"
			drop if first_census_pop_black_perc < 0.05

        reg ${dv`x'} ${nonpar} ${controls} year_* countyfe_* ///
                , cluster($cluster)
        predict double e if e(sample), resid
        sum e
        assert r(mean) <= r(sd)/5
        gen ln_e2 = log(e^2)
        reg ln_e2 countyfe* if e(sample)
        predict logged_fgls_weight if e(sample), xb
        generate fgls_weight = 1/(exp(logged_fgls_weight)^0.5)
        save ctyMIw`i', replace

    }




	* regression
	*-----------

    eststo `est':	miest ctyMIw reg ${dv`x'} ${nonpar} ${controls} year_* countyfe_* ///
                        [aw=fgls_weight] ///
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
    forvalues i = 1/5 {

        use ctyMI`i', clear

			keep if  state == "Georgia" | state == "Alabama"
			//drop if (county_name == "Collier" | county_name == "Hardee" | county_name == "Hendry" ///
						//| county_name == "Hillsborough" | county_name == "Monroe") & state == "Florida"
            drop if first_census_pop_black_perc < 0.05


        reg  ${dv`x'} ${nonpar} ${controls} year_* countyfe_* ///
                        if year <= 1965 | year >= 1975 , cluster($cluster)
        predict double e if e(sample), resid
        sum e
        assert r(mean) <= r(sd)/5
        gen ln_e2 = log(e^2)
        reg ln_e2 countyfe* if e(sample)
        predict logged_fgls_weight if e(sample), xb
        generate fgls_weight = 1/(exp(logged_fgls_weight)^0.5)
        save ctyMIw`i', replace

    }



	* regression
	*-----------
	eststo `est':	miest ctyMIw reg ${dv`x'} ${nonpar} ${controls} year_* countyfe_* ///
                        [aweight = fgls_weight] ///
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

                        distinct state if ${dv`x'} != .
                        estadd scalar clusters = `r(ndistinct)': `est'

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

		using "table_cty_threefold_examiner_MI_fgls.tex",
			b(a2) label replace nogaps compress se(a2) bookt
			noconstant nodepvars star(* 0.1 ** 0.05 *** 0.01)
			fragment  substitute(\_ _)

            drop(countyfe_* year_* _cons)


			stats(      plus_15
                        plus_15_pvalue
                        N2
                        statefixed
						yearfixed
                        period
                        clusters
						,

				labels("Diff-in-Diff, 1980"
                        "Diff-in-Diff, 1980, pvalue"
                        "No. Obs"
                        "State FE"
						"Year FE"
                        "Sample Period"
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
